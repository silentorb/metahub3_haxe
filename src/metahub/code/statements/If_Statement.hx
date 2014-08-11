package metahub.code.statements;

/**
 * ...
 * @author Christopher W. Johnson
 */
class If_Statement extends Statement {

	public function new() {

	}

  public function resolve(scope:Scope):Dynamic {
    for (s in statements) {
      s.resolve(scope);
    }
    return null;
  }

}