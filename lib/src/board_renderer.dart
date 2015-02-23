part of client;

class BoardRenderer {

  final BoardProgram _boardProgram;

  webgl.Buffer _indexBuffer;
  Board _board;

  BoardRenderer(this._boardProgram);

  void setBoard(Board board) {
    this._board = board;

    var positionData = [];
    var positionOffsetData = [];
    var normalData = [];
    var textureData = [];
    var indexData = [];

    var yAxis = new Vector3(0.0, 1.0, 0.0);

    // Vector to translate cells out of the scene to make them appear empty.
    var emptyTranslation = new Vector3(0.0, -100.0, 0.0);

    var blockGL = new BlockGL(board.outerRadius, board.innerRadius, board.numCells);

    var totalRingTranslation = new Vector3(0.0, 0.0, 0.0);
    for (var i = 0; i < board.numRings; i++) {
      var totalCellRotation = new Quaternion.fromAxisAngle(yAxis, 0.0);
      for (var j = 0; j < board.numCells; j++) {
        var cell = board.rings[i].cells[j];

        var color = cell.block != null ? cell.block.color : BlockColor.RED;
        textureData.addAll(blockGL.getTextureCoords(color));

        indexData.addAll(blockGL.indices.map((index) {
          var offset = (i * board.numCells + j) * BlockGL.numIndices;
          return offset + index;
        }));

        for (var k = 0; k < blockGL.vertices.length; k++) {
          var rotatedVertex = totalCellRotation.rotate(totalRingTranslation + blockGL.vertices[k]);
          if (cell.block == null) {
            rotatedVertex += emptyTranslation;
          }

          positionData.add(rotatedVertex.x);
          positionData.add(rotatedVertex.y);
          positionData.add(rotatedVertex.z);

          positionOffsetData.add(cell.positionOffset.x);
          positionOffsetData.add(cell.positionOffset.y);
          positionOffsetData.add(cell.positionOffset.z);

          var rotatedNormal = totalCellRotation.rotate(blockGL.normals[k]);
          normalData.add(rotatedNormal.x);
          normalData.add(rotatedNormal.y);
          normalData.add(rotatedNormal.z);
        }
        totalCellRotation *= blockGL.cellRotation;
      }
      totalRingTranslation += blockGL.ringTranslation;
    }

    var gl = _boardProgram.gl;
    var positionBuffer = createArrayBuffer(gl, positionData);
    var positionOffsetBuffer = createArrayBuffer(gl, positionOffsetData);
    var normalBuffer = createArrayBuffer(gl, normalData);
    var textureBuffer = createArrayBuffer(gl, textureData);

    gl
      ..bindBuffer(webgl.ARRAY_BUFFER, positionBuffer)
      ..enableVertexAttribArray(_boardProgram.positionAttrib)
      ..vertexAttribPointer(_boardProgram.positionAttrib, 3, webgl.FLOAT, false, 0, 0);

    gl
      ..bindBuffer(webgl.ARRAY_BUFFER, positionOffsetBuffer)
      ..enableVertexAttribArray(_boardProgram.positionOffsetAttrib)
      ..vertexAttribPointer(_boardProgram.positionOffsetAttrib, 3, webgl.FLOAT, false, 0, 0);

    gl
      ..bindBuffer(webgl.ARRAY_BUFFER, normalBuffer)
      ..enableVertexAttribArray(_boardProgram.normalAttrib)
      ..vertexAttribPointer(_boardProgram.normalAttrib, 3, webgl.FLOAT, false, 0, 0);

    gl
      ..bindBuffer(webgl.ARRAY_BUFFER, textureBuffer)
      ..enableVertexAttribArray(_boardProgram.textureCoordAttrib)
      ..vertexAttribPointer(_boardProgram.textureCoordAttrib, 2, webgl.FLOAT, false, 0, 0);

     _indexBuffer = createElementArrayBuffer(gl, indexData);
  }

  void render() {
    if (_board == null) {
      return;
    }

    var rotationMatrix = new Matrix4.rotation(0.0, _board.rotationY, 0.0);
    var translationMatrix = new Matrix4.translation(0.0, _board.translationY, 0.0);

    _boardProgram.gl
      ..uniformMatrix4fv(_boardProgram.boardRotationMatrixUniform, false, rotationMatrix.floatList)
      ..uniformMatrix4fv(_boardProgram.boardTranslationMatrixUniform, false, translationMatrix.floatList)
      ..uniform1f(_boardProgram.grayscaleAmountUniform, _board.grayscaleAmount)
      ..uniform1f(_boardProgram.blackAmountUniform, _board.blackAmount);

    _boardProgram.gl
      ..bindBuffer(webgl.ELEMENT_ARRAY_BUFFER, _indexBuffer)
      ..drawElements(webgl.TRIANGLES, 36 * _board.numRings * _board.numCells, webgl.UNSIGNED_SHORT, 0);
  }
}