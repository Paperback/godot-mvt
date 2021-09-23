using Godot;
using System;

[Tool]
public class MvtPlugin : EditorPlugin
{
	public override void _Ready()
	{
		GD.Print("HELLO HERE FROM PLUGIN");
	}
	
	public override void _EnterTree()
	{
		// Initialization of the plugin goes here
		// Add the new type with a name, a parent type, a script and an icon
		var script = GD.Load<Script>("mvt_tile.cs");
		AddCustomType("MvtTile", "Node", script, null);
	}

	public override void _ExitTree()
	{
	//RemoveCustomType("MvtTile");
	// Clean-up of the plugin goes here
	// Always remember to remove it from the engine when deactivated
	}
}
