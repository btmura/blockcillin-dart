part of blockcillin;

/// Renderer of the selector.
class SelectorRenderer {

  final webgl.RenderingContext _gl;
  final SelectorProgram _program;
  webgl.Buffer _positionBuffer;
  webgl.Buffer _textureCoordBuffer;
  webgl.Buffer _indexBuffer;
  int _indexCount;

  SelectorRenderer(this._gl, this._program);

  void init(BoardGeometry geo) {
    // prepare buffers to draw 2 selectors centered at origin: [][]

    // scale up the selector to draw over the board
    var scale = 1.1;
    var olv = geo.outerBlockLeftVector * scale;
    var ocv = geo.outerVector * scale;
    var orv = geo.outerBlockRightVector * scale;

    // l is left edge of left selector
    var lx = olv.x;
    var lz = olv.z;

    // c is the right edge of left selector, left edge of right selector
    var cz = ocv.z;

    // r is right edge of right selector
    var rx = orv.x;
    var rz = orv.z;

    // hh is half height
    var hh = rx / 2;

    var positions = [
      // left selector
      new Vector3(0.0, hh, cz),  // rt
      new Vector3(lx, hh, lz),   // lt
      new Vector3(lx, -hh, lz),  // lb
      new Vector3(0.0, -hh, cz), // rb

      // right selector
      new Vector3(rx, hh, rz),   // rt
      new Vector3(0.0, hh, cz),  // lt
      new Vector3(0.0, -hh, cz), // lb
      new Vector3(rx, -hh, rz),  // rb
    ];

    var textureCoords = [
      // left selector
      new Vector2(1.0, 0.0), // rt
      new Vector2(0.0, 0.0), // lt
      new Vector2(0.0, 1.0), // lb
      new Vector2(1.0, 1.0), // rb

      // right selector
      new Vector2(1.0, 0.0), // rt
      new Vector2(0.0, 0.0), // lt
      new Vector2(0.0, 1.0), // lb
      new Vector2(1.0, 1.0), // rb
    ];

    // use the selector texture in the tile set
    textureCoords = _toTextureTileCoords(textureCoords, 0, 4);

    var indices = [
      0, 1, 2,
      2, 3, 0,

      4, 5, 6,
      6, 7, 4,
    ];
    _indexCount = indices.length;

    _positionBuffer = newArrayBuffer(_gl, Vector3.flatten(positions));
    _textureCoordBuffer = newArrayBuffer(_gl, Vector2.flatten(textureCoords));
    _indexBuffer = newElementArrayBuffer(_gl, indices);
  }

  void render() {
    if (_indexBuffer != null) {
      _gl.enable(webgl.BLEND);

      _program.useProgram();
      _program.enableArrays(_positionBuffer, _textureCoordBuffer);
      drawTriangles(_gl, _indexBuffer, _indexCount);
      _program.disableArrays();

      _gl.disable(webgl.BLEND);
    }
  }
}
