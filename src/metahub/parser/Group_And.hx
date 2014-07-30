package metahub.parser;

class Group_And extends Group {

  override function __test__(start:Position, depth:Int):Result {
    var length = 0;
    var position = start, end = position;
    var info_items = new Array<Result>();
    var matches = new Array<Match>();

    for (pattern in patterns) {
//trace('and', position.get_coordinate_string());
      var result = pattern.test(position, depth + 1);
			if (result.end.get_offset() > end.get_offset())
				end = result.end;

      info_items.push(result);
      if (!result.success)
        return failure(start, end, info_items);

      var match:Match = cast result;
      matches.push(match);
      position = position.move(match.length);

      length += match.length;
    }

    return success(start, length, info_items, matches);
  }

  override function get_data(match:Match):Dynamic {
    var result = new Array<Dynamic>();
    for (child in match.matches) {
      result.push(child.get_data());
    }
    return result;
  }
}