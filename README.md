# Godot-MVT

Ingest [mapbox vector tiles](https://docs.mapbox.com/data/tilesets/guides/vector-tiles-introduction/) from tile servers and import them as resources.

Provides godot resource abstractions for
* MvtLayer
* MvtLayerTiles
* MvtTile
* MvtGeometry

## Limitations

* Ingestion over HTTP only for now
* C# and godot 3.4
* Tested with [Martin](https://github.com/maplibre/martin)

## Build godot geometry from vector tiles
```gdscript
var tile: MvtTile = load('res://data/tile/6/32-32.tres')
for geometry in tile.geometry:
	for g in geometry.size():
		var geom: Dictionary = geometry.get_index(g)
		print(geom.type) # Polygon, MultiPolygon, etc
		print(geom.properties) # Dictionary of supplied attributes
		var polygon := Polygon2D.new()
		polygon.set_polygon(geom.data)
		add_child(polygon) # voila
```
