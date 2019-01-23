# SpriteMap
A tilemap for Godot engine that runs at much much higher performance than the built-in TileMap. It sacrifices some extendability, such as per-tile materials and different tile sizes, in favor of a enormous performance boost, only limited in speed by the shader (which slows down with screen size).

It should be almost a drop-in replacement for the base TileMap and TileSet (however there is no TileSet editor, it must be done through code).

---

Benchmark | Tiles | FPS
--- | --- | ---
Godot TileMap | 4096 | +50+
SpriteMap | 65536 | 600+

`Benchmarks run on Intel Integrated Graphics`
