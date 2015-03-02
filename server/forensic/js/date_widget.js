var dateWidget = function () {

    var public = {};
    public.window_start;
    public.window_end;

    function makeChart(users, trail, domain) {
        var jsonData = JSON.stringify({users: users.toString(), trail: trail, domain: domain});
        $.ajax({
            url: '/datawake/forensic/dateservice/chart',
            type: 'POST',
            data: jsonData,
            dataType: 'json',
            contentType: 'application/json',
            success: function (data) {
                //console.log("dataservice GET -> "+response)
                var processed = processData(data.data);
                drawChart(processed);

            },
            error: function (jqxhr, textStatus, reason) {
                console.log("date_widget makeChart error " + textStatus + " " + reason);
            }
        })
    }

    function processData(data) {

        var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        if (data == undefined || data.length === 0) {
            return {dayCounts: [], min_ts: 0, max_ts: 0, maxCounts: 0};
        }

        function toDay(ts) {
            var d = new Date(ts * 1000);
            //return d.getFullYear()+"-"+(d.getMonth()+1)+"-"+ d.getDate()
            return months[d.getMonth()] + " " + d.getDate();
        }

        function toDayStart(ts) {
            var d = new Date(ts * 1000);
            d = new Date(d.getFullYear(), d.getMonth(), d.getDate());
            return d.getTime();
        }

        function toDayEnd(ts) {
            var ts = toDayStart(ts);
            return ts + (60 * 60 * 24 * 1000);
        }

        var maxCounts = 0;
        var dayCounts = [];
        var curr = {day: toDay(data[0].ts), count: 0};
        for (i in data) {
            row = data[i];
            var day = toDay(row.ts);
            if (curr.day == day) {
                curr.count += row.count;
            }
            else {
                dayCounts.push(curr);
                curr = {day: day, count: row.count};
            }
            if (curr.count > maxCounts) {
                maxCounts = curr.count;
            }
        }
        dayCounts.push(curr);
        var min = toDayStart(data[0].ts);
        var max = toDayEnd(data[data.length - 1].ts);

        return {dayCounts: dayCounts, min_ts: min, max_ts: max, maxCounts: maxCounts};
    }


    function drawChart(processedData) {
        public.data = processedData;
        var data = processedData.dayCounts;
        var min_ts = processedData.min_ts;
        var max_ts = processedData.max_ts;
        var maxCounts = processedData.maxCounts;


        d3.select(".chart").select("g").remove();
        var margin = {top: 20, right: 30, bottom: 60, left: 40};
        var width = $("#dateChart").width() - margin.left - margin.right;
        var height = 150 - margin.top - margin.bottom;

        //var min_ts = data[0].ts
        //var max_ts = data[data.length - 1].ts
        public.window_start = parseInt(min_ts / 1000);
        public.window_end = parseInt(max_ts / 1000);

        var ts_scale = d3.scale.linear()
            .domain([0, width])
            .range([public.window_start, public.window_end]);


        var x = d3.scale.ordinal()
            .rangeRoundBands([0, width], .05)
            .domain(data.map(function (d) {
                return d.day;
            }));


        var y = d3.scale.linear()
            .domain([0, maxCounts])
            .range([height, 0]);

        var xAxis = d3.svg.axis()
            .scale(x)
            .orient("bottom");

        var yAxis = d3.svg.axis()
            .scale(y)
            .orient("left");


        var chart = d3.select(".chart")
            .attr("width", width + margin.left + margin.right)
            .attr("height", height + margin.top + margin.bottom)
            .append("g")
            .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

        var barWidth = width / data.length;

        var bar = chart.selectAll("g")
            .data(data)
            .enter().append("g")
            .attr("transform", function (d, i) {
                return "translate(" + i * barWidth + ",0)";
            });

        chart.append("g")
            .attr("class", "x axis")
            .attr("transform", "translate(0," + height + ")")
            .call(xAxis)
            .selectAll("text")
            .style("text-anchor", "end")
            .attr("dx", "-.8em")
            .attr("dy", "-.6em")
            .attr("transform", function (d) {
                return "rotate(-90)";
            });

        chart.append("g")
            .attr("class", "y axis")
            .call(yAxis);


        chart.selectAll(".bar")
            .data(data)
            .enter().append("rect")
            .attr("class", "bar")
            .attr("x", function (d) {
                return x(d.day);
            })
            .attr("y", function (d) {
                return y(d.count);
            })
            .attr("height", function (d) {
                return height - y(d.count);
            })
            .attr("width", x.rangeBand());

        var brush = d3.svg.brush()
            .x(x)
            .on("brush", function () {
                if (brush.empty()) {
                    public.window_start = min_ts / 1000;
                    public.window_end = max_ts / 1000;
                    console.log("brush start: " + new Date(1000 * public.window_start) + " end: " + new Date(1000 * public.window_end));
                }
                else {
                    var extent = brush.extent();
                    public.window_start = parseInt(ts_scale(extent[0]));
                    public.window_end = parseInt(ts_scale(extent[1]));
                    console.log("brush start: " + new Date(1000 * public.window_start) + " end: " + new Date(1000 * public.window_end));
                }
            })


        var brushg = chart.append("g")
            .attr("class", "brush")
            .call(brush)
            .selectAll("rect")
            .attr("y", -6)
            .attr("height", height + 7);


    }


    public.makeChart = makeChart;


    return public;
}();

