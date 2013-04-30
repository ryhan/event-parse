event-parse
===========

Fantastical-style natural language parsing of events into title, locations, and times. Utilizes date.js parsing method.

## Usage

Calling `Event.parse(YOUR_STRING)` will return an object with the following properties.
- title (string) the main text associated with the event
- location (string)
- startTime (js date object)

### Simple example
```javascript
// parse some natural language describing an event
Event.parse("Pick up milk at Giant Eagle on Friday afternoon");
...
// output of Event.parse
{
  title: "Pick up milk", 
  location: "Giant Eagle", 
  startTime: Fri May 03 2013 16:00:00 GMT-0400 (EDT)
}
```

### Realtime Example
The real value of clientside event parsing is in providing realtime feedback to the user. 
In this example we're watching for natural language in `input#parsedField`, and applying the parsed attributed to `input#parsedTitle`, `input#parsedLocation`, and `input#parsedStart`.

To see a working example, open up `index.html` in the `/demo` folder.

```javascript
// Select our inputs
var $parsedInput = $('#parsedField'),
    $parsedTitle = $('#parsedTitle'),
    $parsedLocation = $('#parsedLocation'),
    $parsedStart = $('#parsedStart');

// Create a function that reads, parses, and updates the fields,
// while also preventing things from running too slowly.
var parseAndUpdate = _.debounce(function(){

  // Read and parse the natural language string from $parsedInput
  var parsed = Event.parse($parsedInput.val());
  
  // Apply the parsed attributed to their respective fields
  $parsedTitle.val(parsed.title);
  $parsedLocation.val(parsed.location);
  $parsedStart.val(parsed.startTime.toString("dddd, MMMM dd, yyyy h:mm:ss tt"));
  
}, 100);

// Listen for any changes (keystrokes) in our main input.
$parsedInput.keypress(parseAndUpdate);
```
