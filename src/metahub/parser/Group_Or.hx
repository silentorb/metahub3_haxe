package metahub.parser;

class Group_Or extends Group {

  override function __test__(position:Position, depth:Int):Result {
    var info_items = new Array<Result>();
		var end = position;

    for (pattern in patterns) {
      var result = pattern.test(position, depth + 1);
			if (result.end.get_offset() > end.get_offset())
				end = result.end;

      info_items.push(result);
      if (result.success) {
//        match.children.push(result);
//        result = info;
        var match:Match = cast result;
        return success(position, match.length, info_items, [ match ]);
      }
    }

    return failure(position, end, info_items);
  }

  override function get_data(match:Match):Dynamic {
    return match.matches[0].get_data();
  }
}