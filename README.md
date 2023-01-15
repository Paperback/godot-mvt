# Godot-MVT

Standalone godot application that can ingest [mapbox vector tiles](https://docs.mapbox.com/data/tilesets/guides/vector-tiles-introduction/) from tile servers using [tileJSON](https://github.com/mapbox/tilejson-spec) and save them as resources to be used in your projects. Uses C# and multi-threading so it's pretty quick. Resource generation from this repo requires C# and godot 3.x to run but the resources it generates will work in vanilla godot 3 or 4.

Provides godot resource abstractions for:
* MvtLayer
* MvtLayerTiles
* MvtTile
* MvtGeometry

Supports attributes.

## Limitations

* Currently only ingests via HTTP.
* Tested with [Martin](https://github.com/maplibre/martin) tile server. Have problems with your MVT server? [let me know](https://github.com/Paperback/Godot-MVT/issues).
* Due to fundamental limitations in godot's pooled memory, it can crash when building *extremely* large features. To prevent this split your features up or reduce complexity for larger tiles, and only process 1 layer at a time when importing. This is fixed in godot 4.

## Render geometry in godot from vector tiles
```gdscript
var tile: MvtTile = load('res://data/tile/6/32-32.tres')
var geometry: MvtGeometry = tile.geometry
for g in geometry.size():
	var geom: Dictionary = geometry.get_index(g)
	print(geom.type) # Point, Line, Polygon, etc
	print(geom.properties) # Dictionary of supplied attributes
	var polygon := Polygon2D.new()
	polygon.set_polygon(geom.data)
	polygon.set_meta('gid', geom.properties.gid) # for example
	add_child(polygon) # voila!
```
