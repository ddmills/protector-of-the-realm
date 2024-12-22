package screens.play.components;

// @:uiComp("inspect-building")
class InspectBuildingView extends h2d.Flow implements h2d.domkit.Object
{
	static var SRC = <inspect-building-view>
			<text text={"testing"} />
		</inspect-building-view>;

	public function new(title:String, ?parent:h2d.Object)
	{
		super(parent);
		initComponent();
	}
}
