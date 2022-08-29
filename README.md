# Godot-MVT

Standalone godot application that can ingest [mapbox vector tiles](https://docs.mapbox.com/data/tilesets/guides/vector-tiles-introduction/) from tile servers and save them as resources.

Provides godot resource abstractions for
* MvtLayer
* MvtLayerTiles
* MvtTile
* MvtGeometry

## Limitations

* Ingests HTTP only for now
* C# and godot 3.4 (godot 4 support may arrive later)
* Tested with [Martin](https://github.com/maplibre/martin) MVT server. Have problems with your MVT server? [Please let me know](https://github.com/Paperback/Godot-MVT/issues)

## Build godot geometry from vector tiles
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
