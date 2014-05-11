package code;

import engine.Node;
import engine.IPort;
import engine.Port;

enum Functions {
  none;
  sum;
}

class Function_Calls {
  public static function call(id:Functions, node:Node) {
    var output:Port = cast node.get_port(0);
    switch (id) {
      case Functions.sum:
        output.set_value(sum(node.get_port(1)));

      default:
    }
  }

  static function sum(port:IPort):Dynamic {
    var total = 0;
    for (other in port.dependencies) {
    var o:Port = cast other;
      total += o.get_value();
    }

    return total;
  }
}