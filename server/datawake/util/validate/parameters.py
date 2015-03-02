def required_parameters(params):
    def validate(callback):
        def new_def(**kwargs):
            for param in params:
                value = kwargs.get(param, u'')
                if value is u'':
                    raise ValueError("Param: %s cannot be empty" % param)
            return callback(**kwargs)

        new_def.func_name = callback.func_name
        return new_def

    return validate