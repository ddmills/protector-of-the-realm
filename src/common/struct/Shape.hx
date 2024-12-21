package common.struct;

enum Shape
{
	POINT;
	CIRCLE(radius:Int);
	ELLIPSE(radius1:Int, radius2:Int);
	RECTANGLE(width:Int, height:Int);
}
