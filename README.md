event-parse
===========

Fantastical-style natural language parsing of events into title, locations, and times. Utilizes date.js parsing method.

## Usage

Calling `Event.parse(YOUR_STRING)` will return an object with the following properties.
- title (string) the main text associated with the event
- location (string)
- startTime (date object)

### Example
```javascript
Event.parse("Pick up milk at Giant Eagle on Friday afternoon");
/*
Returns 
{
  title: "Pick up milk", 
  location: "Giant Eagle", 
  startTime: Fri May 03 2013 16:00:00 GMT-0400 (EDT)
}
*/
``
