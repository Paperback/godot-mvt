using Godot;
using System;
using Mapbox.VectorTile;
using Mapbox.VectorTile.Geometry;
using System.Collections.Generic;
using Mapbox.VectorTile.ExtensionMethods;

[Tool]
public class MvtTile : Node
{
	public List<string> layers;
	public List<List<long>> features;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		
	}
	
	public void import(Node node, byte[] bufferedData, String name)
	{
		
		//GD.Print("TEST");
		uint? clipBuffer = null;
		VectorTile tile = new VectorTile(bufferedData);
//		List<List<List<Mapbox.VectorTile.Geometry.Point2d<long>>>> geometry = new List<List<List<Mapbox.VectorTile.Geometry.Point2d<long>>>>();
		foreach (var layerName in tile.LayerNames())
		{
			var layer = tile.GetLayer(layerName);
			for (int i = 0; i < layer.FeatureCount(); i++)
			{
				var feature = layer.GetFeature(i, clipBuffer, 1.0f);
				if (feature.GeometryType == GeomType.UNKNOWN) { continue; }
				
				//build geojson properties object from resolved properties
//				string geojsonProps = string.Format(
//					NumberFormatInfo.InvariantInfo
//					, @"{{""id"":{0},""lyr"":""{1}""{2}{3}}}"
//					, feat.Id
//					, layer.Name
//					, keyValue.Count > 0 ? "," : ""
//					, string.Join(",", keyValue.ToArray())
//				);

				//work through geometries
				string type = feature.GeometryType.Description();
				foreach(var parts in feature.Geometry<long>(clipBuffer, 1.0f))
				{
					List<Vector2> geom = new List<Vector2>();
					foreach(var point in parts)
					{
						geom.Add(new Vector2(point.X, point.Y));
//						node.Call("geometry_point", new Vector2D(point.X, point.Y));
					}
					node.Call("geometry_add", geom.ToArray(), name);
				}
				
//				var parts = feature.Geometry<long>(clipBuffer, 1.0f);
//				node.Call("geometry_add");
//				features.Add(geometry);
				
//				List<List<>> geomWgs84 = feat.GeometryAsWgs84(zoom, tileColumn, tileRow);
//				if (geomWgs84.Count > 1)
//				{
//
//				}
			}
		}
	}

	public string importGeoJson(byte[] bufferedData)
	{
		uint? clipBuffer = null;
		bool outGeoJson = false;
		ulong? zoom = 1;
		ulong? tileCol = 0;
		ulong? tileRow = 0;

		VectorTile tile = new VectorTile(bufferedData);
		return tile.ToGeoJson(zoom.Value, tileCol.Value, tileRow.Value, clipBuffer);
//
//		foreach (string lyrName in tile.LayerNames())
//		{
//			VectorTileLayer lyr = tile.GetLayer(lyrName);
//			GD.Print(string.Format("------------ {0} ---------", lyrName));
//			//if (lyrName != "building") { continue; }
//			int featCnt = lyr.FeatureCount();
//			for (int i = 0; i < featCnt; i++)
//			{
//				VectorTileFeature feat = lyr.GetFeature(i, clipBuffer);
//				GD.Print(string.Format("feature {0}: {1}", i, feat.GeometryType));
//				Dictionary<string, object> props = feat.GetProperties();
//				foreach (var prop in props)
//				{
//					GD.Print(string.Format("   {0}\t : ({1}) {2}", prop.Key, prop.Value.GetType(), prop.Value));
//				}
//			}
//		}
	}

//  // Called every frame. 'delta' is the elapsed time since the previous frame.
//  public override void _Process(float delta)
//  {
//      
//  }
}
