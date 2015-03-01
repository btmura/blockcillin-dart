part of blockcillin;

/// Renderer of the board.
class BoardRenderer {

  /// Vector to translate cells out of the scene to make them appear empty.
  static final Vector3 _emptyTranslation = new Vector3(0.0, -100.0, 0.0);

  final webgl.RenderingContext _gl;
  final BoardProgram _program;
  webgl.Buffer _positionBuffer;
  webgl.Buffer _positionOffsetBuffer;
  webgl.Buffer _normalBuffer;
  webgl.Buffer _textureCoordBuffer;
  webgl.Buffer _indexBuffer;
  Board _board;

  BoardRenderer(this._gl, this._program);

  void init(Board board, BoardGeometry geometry) {
    this._board = board;

    var blockGL = new BlockGL(geometry);

    var positions = [];
    var positionOffsets = [];
    var normals = [];
    var textureCoords = [];
    var indices = [];

    var totalRingTranslation = new Vector3(0.0, 0.0, 0.0);
    for (var i = 0; i < board.numRings; i++) {
      var totalCellRotation = new Quaternion.fromAxisAngle(_yAxis, 0.0);
      for (var j = 0; j < board.numCells; j++) {
        var cell = board.rings[i].cells[j];

        var color = cell.block != null ? cell.block.color : BlockColor.RED;
        textureCoords.addAll(blockGL.getTextureCoords(color));

        indices.addAll(blockGL.indices.map((index) {
          var offset = (i * board.numCells + j) * BlockGL.uniqueIndexCount;
          return offset + index;
        }));

        for (var k = 0; k < blockGL.vertices.length; k++) {
          var rotatedVertex = totalCellRotation.rotate(totalRingTranslation + blockGL.vertices[k]);
          if (cell.block == null) {
            rotatedVertex += _emptyTranslation;
          }

          positions.add(rotatedVertex);
          positionOffsets.add(cell.positionOffset);
          normals.add(totalCellRotation.rotate(blockGL.normals[k]));
        }
        totalCellRotation *= blockGL.cellRotation;
      }
      totalRingTranslation += blockGL.ringTranslation;
    }

    _positionBuffer = newArrayBuffer(_gl, Vector3.flatten(positions));
    _positionOffsetBuffer = newArrayBuffer(_gl, Vector3.flatten(positionOffsets));
    _normalBuffer = newArrayBuffer(_gl, Vector3.flatten(normals));
    _textureCoordBuffer = newArrayBuffer(_gl, Vector2.flatten(textureCoords));
    _indexBuffer = newElementArrayBuffer(_gl, indices);
  }

  void render() {
    if (_board == null) {
      return;
    }

    _program.useProgram();

    if (_board.dirtyRotationY || _board.dirtyTranslationY) {
      var rm = new Matrix4.rotation(0.0, _board.rotationY, 0.0);
      var tm = new Matrix4.translation(0.0, _board.translationY, 0.0);
      _program.setBoardMatrix(tm * rm);
    }

    if (_board.dirtyGrayscale) {
      _program.setGrayscale(_board.grayscale);
    }

    if (_board.dirtyBlack) {
      _program.setBlack(_board.black);
    }

    _program.enableArrays(_positionBuffer, _positionOffsetBuffer, _normalBuffer, _textureCoordBuffer);

    _gl.bindBuffer(webgl.ELEMENT_ARRAY_BUFFER, _indexBuffer);
    _gl.drawElements(webgl.TRIANGLES, _board.numRings * _board.numCells * BlockGL.indexCount, webgl.UNSIGNED_SHORT, 0);

    _program.disableArrays();
  }
}