part of client;

class BoardRenderer {

  final GLProgram _glProgram;
  final ImageElement _textureImage;

  webgl.Buffer _indexBuffer;
  Board _board;

  BoardRenderer(this._glProgram, this._textureImage);

  void init() {
    var gl = _glProgram.gl;
    gl
      ..bindTexture(webgl.TEXTURE_2D, gl.createTexture())
      ..texImage2D(webgl.TEXTURE_2D, 0, webgl.RGBA, webgl.RGBA, webgl.UNSIGNED_BYTE, _textureImage)
      ..texParameteri(webgl.TEXTURE_2D, webgl.TEXTURE_MAG_FILTER, webgl.LINEAR)
      ..texParameteri(webgl.TEXTURE_2D, webgl.TEXTURE_MIN_FILTER, webgl.LINEAR_MIPMAP_NEAREST)
      ..generateMipmap(webgl.TEXTURE_2D);
  }

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

    var gl = _glProgram.gl;
    var positionBuffer = createArrayBuffer(gl, positionData);
    var positionOffsetBuffer = createArrayBuffer(gl, positionOffsetData);
    var normalBuffer = createArrayBuffer(gl, normalData);
    var textureBuffer = createArrayBuffer(gl, textureData);

    gl
      ..bindBuffer(webgl.ARRAY_BUFFER, positionBuffer)
      ..enableVertexAttribArray(_glProgram.positionAttrib)
      ..vertexAttribPointer(_glProgram.positionAttrib, 3, webgl.FLOAT, false, 0, 0);

    gl
      ..bindBuffer(webgl.ARRAY_BUFFER, positionOffsetBuffer)
      ..enableVertexAttribArray(_glProgram.positionOffsetAttrib)
      ..vertexAttribPointer(_glProgram.positionOffsetAttrib, 3, webgl.FLOAT, false, 0, 0);

    gl
      ..bindBuffer(webgl.ARRAY_BUFFER, normalBuffer)
      ..enableVertexAttribArray(_glProgram.normalAttrib)
      ..vertexAttribPointer(_glProgram.normalAttrib, 3, webgl.FLOAT, false, 0, 0);

    gl
      ..bindBuffer(webgl.ARRAY_BUFFER, textureBuffer)
      ..enableVertexAttribArray(_glProgram.textureCoordAttrib)
      ..vertexAttribPointer(_glProgram.textureCoordAttrib, 2, webgl.FLOAT, false, 0, 0);

     _indexBuffer = createElementArrayBuffer(gl, indexData);
  }

  void render() {
    if (_board == null) {
      return;
    }

    var rotationMatrix = new Matrix4.rotation(0.0, _board.rotationY, 0.0);
    var translationMatrix = new Matrix4.translation(0.0, _board.translationY, 0.0);

    _glProgram.gl
      ..uniformMatrix4fv(_glProgram.boardRotationMatrixUniform, false, rotationMatrix.floatList)
      ..uniformMatrix4fv(_glProgram.boardTranslationMatrixUniform, false, translationMatrix.floatList)
      ..uniform1f(_glProgram.grayscaleAmountUniform, _board.grayscaleAmount)
      ..uniform1f(_glProgram.blackAmountUniform, _board.blackAmount);

    _glProgram.gl
      ..bindBuffer(webgl.ELEMENT_ARRAY_BUFFER, _indexBuffer)
      ..drawElements(webgl.TRIANGLES, 36 * _board.numRings * _board.numCells, webgl.UNSIGNED_SHORT, 0);
  }
}