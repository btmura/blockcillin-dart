part of blockcillin;

/// Number of tiles per row in the single square texture.
const double _numTextureTiles = 8.0;

/// Relative size of a single texture tile in the larger texture.
const double _textureTileSize = 1.0 / _numTextureTiles;

/// Returns a absolute coordinate list for a tile at (x, y) from relative coordinates.
List<Vector2> _toTextureTileCoords(List<Vector2> relCoords, int x, int y) {
 return relCoords.map((rc) {
    var ac = rc * _textureTileSize;
    ac.x += x * _textureTileSize;
    ac.y += y * _textureTileSize;
    return ac;
 }).toList();
}