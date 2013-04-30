# eventParser.coffee

class eventParser

  getResults: () ->
    @_clean()
    @_getLocation()
    @_clean()
    title = @title
    location = @location
    startTime = @startTime
    return {title, location, startTime} 

  _clean: () ->
    if @title
      console.log @title.lastIndexOf(" at") 
      console.log @title.length - 4

      if @title.lastIndexOf(" at") == @title.length - 4
        @title = @title.substring(0, @title.length - 4)

      if @title.lastIndexOf(" on") == @title.length - 4
        @title = @title.substring(0, @title.length - 4)

      if @title.lastIndexOf(" for") == @title.length - 5
        @title = @title.substring(0, @title.length - 5)

  _getLocation: () ->
    split = @title.split(" at ")
    @title = split[0]
    @location = split[1]
    return if @location

    split = @title.split(" in ")
    @title = split[0]
    @location = split[1]
    return if @location

    split = @title.split(" on ")
    @title = split[0]
    @location = split[1]
    return if @location


  parse: (text) -> 
    # initialize values
    @text = text
    @title = text
    @location = ''
    @startTime = Date.parse text

    # run basic transformations
    #text = @_initialTransform @text
    @_splitter text
    return @getResults() if @startTime

    #text = @_roughTransform text
    #@_splitter text
    #return @getResults() if @startTime

    @startTime = Date.parse @_inferredTime @text
    @title = @text
    return @getResults() if @startTime

    #@startTime = Date.parse text
    #console.log "basic " + text
    #return @getResults() if @startTime
   
    #@_splitter text
    #console.log "split " + @title
    #return @getResults() if @startTime

    #text = @_roughTransform text
    #@_splitter text
    # @startTime = Date.parse(text)
    #console.log "rough " + text
    #return @getResults() if @startTime

    #@startTime = Date.parse @_inferredTime(text)
    #console.log "infer " + text
    #return @getResults() if @startTime

  _isDate: (text) =>
    text = @_transform text
    console.log text if Date.parse(text)? 
    Date.parse(text)?

  _splitter: (text) ->
    console.log "splitting " + text
    time = ""
    title = text
    words = text.split " "
    guesses = _.filter(_.range(words.length), (n) => @_isDate words[n])

    return unless guesses.length > 0

    guess = guesses[0]
    substrings = _.rest(words, guess)
    options = _.map(_.range(substrings.length), (n) -> _.first(substrings, n+1).join(' '))
    options = _.filter options, @_isDate
    time = _.last options
    title = @title.replace(time, '')

    @startTime = Date.parse(@_transform time)
    @title = title

  _transform: (text) ->
    text = @_initialTransform text
    text = @_roughTransform text
    text = text.replace(/for at/gi, "at")
    text = text.replace(/at at/gi, "at")
    return text

  _initialTransform: (text) ->
    text = text.replace(/midnight/gi, "at 12am")
    text = text.replace(/morning/gi, "at 9am")
    text = text.replace(/midday/gi, "at 11am")
    text = text.replace(/afternoon/gi, "at 4pm")
    text = text.replace(/noon/gi, "at 12pm")
    text = text.replace(/night/gi, "at 9pm")
    text = text.replace(/sometime/gi, "")

  _roughTransform: (text) ->
    text = text.replace(/dinner/gi, "at 6pm")
    text = text.replace(/lunch/gi, "at 12pm")
    text = text.replace(/breakfast/gi, "at 9pm")

  _inferredTime: (text) ->
    text = text.toLowerCase()
    contains = (substring) -> (text.indexOf(substring) != -1)
    return "today at 6pm" if contains "dinner"
    return "today at 12pm" if contains "lunch"
    return "today at 9am" if contains "breakfast"
    return "today at 9am" if contains "morning"
    return "today"



Event = new eventParser()