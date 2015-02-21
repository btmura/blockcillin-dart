part of client;

class BoardRenderer {

  final GLProgram _glProgram;
  final ImageElement _textureImage;

  webgl.Buffer _positionBuffer;
  webgl.Buffer _positionOffsetBuffer;
  webgl.Buffer _normalBuffer;
  webgl.Buffer _textureBuffer;
  webgl.Buffer _indexBuffer;

  BoardRenderer(this._glProgram, this._textureImage);

  void init(Board board) {
    var gl = _glProgram.gl;

    var data = _getVertexAndNormalData(board);
    _positionBuffer = createArrayBuffer(gl, data[0]);
    _positionOffsetBuffer = createArrayBuffer(gl, data[1]);
    _normalBuffer = createArrayBuffer(gl, data[2]);

    var texture = gl.createTexture();
    gl
      ..bindTexture(webgl.TEXTURE_2D, texture)
      ..texImage2D(webgl.TEXTURE_2D, 0, webgl.RGBA, webgl.RGBA, webgl.UNSIGNED_BYTE, _textureImage)
      ..texParameteri(webgl.TEXTURE_2D, webgl.TEXTURE_MAG_FILTER, webgl.LINEAR)
      ..texParameteri(webgl.TEXTURE_2D, webgl.TEXTURE_MIN_FILTER, webgl.LINEAR_MIPMAP_NEAREST)
      ..generateMipmap(webgl.TEXTURE_2D);

    _textureBuffer = createArrayBuffer(gl, _getTextureData(board));
    _indexBuffer = createElementArrayBuffer(gl, _getIndexData(board));
  }

  List<List<double>> _getVertexAndNormalData(Board board) {
    var yAxis = new Vector3(0.0, 1.0, 0.0);
    var theta = 2 * math.PI / board.numCells;
    var cellRotation = new Quaternion.fromAxisAngle(yAxis, theta);

    var outerVector = new Vector3(0.0, 0.0, board.outerRadius);
    var halfSwing = new Quaternion.fromAxisAngle(yAxis, theta / 2);
    var outerSwingVector = halfSwing.rotate(outerVector);
    var ringTranslation = new Vector3(0.0, -outerSwingVector.x * 2, 0.0);

    var vertexVectors = BlockGL.getVertexVectors(board.outerRadius, board.innerRadius, theta);
    var normalVectors = BlockGL.getNormalVectors(theta);

    var positionData = [];
    var positionOffsetData = [];
    var normalData = [];

    // Vector to translate cells out of the scene to make them appear empty.
    var emptyTranslation = new Vector3(0.0, -100.0, 0.0);

    var totalRingTranslation = new Vector3(0.0, 0.0, 0.0);
    for (var i = 0; i < board.numRings; i++) {
      var totalCellRotation = new Quaternion.fromAxisAngle(yAxis, 0.0);
      for (var j = 0; j < board.numCells; j++) {
        var cell = board.rings[i].cells[j];
        for (var k = 0; k < vertexVectors.length; k++) {
          var rotatedVertex = totalCellRotation.rotate(totalRingTranslation + vertexVectors[k]);
          if (cell.block == null) {
            rotatedVertex += emptyTranslation;
          }

          positionData.add(rotatedVertex.x);
          positionData.add(rotatedVertex.y);
          positionData.add(rotatedVertex.z);

          positionOffsetData.add(cell.positionOffset.x);
          positionOffsetData.add(cell.positionOffset.y);
          positionOffsetData.add(cell.positionOffset.z);

          var rotatedNormal = totalCellRotation.rotate(normalVectors[k]);
          normalData.add(rotatedNormal.x);
          normalData.add(rotatedNormal.y);
          normalData.add(rotatedNormal.z);
        }
        totalCellRotation *= cellRotation;
      }
      totalRingTranslation += ringTranslation;
    }

    return [positionData, positionOffsetData, normalData];
  }

  List<double> _getTextureData(Board board) {
    var data = [];
    for (var ring in board.rings) {
      for (var cell in ring.cells) {
        var color = cell.block != null ? cell.block.color : BlockColor.RED;
        data.addAll(BlockGL.getTextureData(color));
      }
    }
    return data;
  }

  List<int> _getIndexData(Board board) {
    var data = [];
    for (var i = 0; i < board.numRings; i++) {
      for (var j = 0; j < board.numCells; j++) {
        data.addAll(BlockGL.getIndexData().map((index) {
          var offset = (i * board.numCells + j) * BlockGL.numIndices;
          return offset + index;
        }));
      }
    }
    return data;
  }

  void render(Board board) {
    var rotationMatrix = new Matrix4.rotation(0.0, board.rotationY, 0.0);
    var translationMatrix = new Matrix4.translation(0.0, board.translationY, 0.0);

    _glProgram.gl
      ..uniformMatrix4fv(_glProgram.boardRotationMatrixUniform, false, rotationMatrix.floatList)
      ..uniformMatrix4fv(_glProgram.boardTranslationMatrixUniform, false, translationMatrix.floatList)
      ..uniform1f(_glProgram.grayscaleAmountUniform, board.grayscaleAmount)
      ..uniform1f(_glProgram.blackAmountUniform, board.blackAmount);

    for (var r = 0; r < board.rings.length; r++) {
      var ring = board.rings[r];
      for (var c = 0; c < ring.cells.length; c++) {
        var cell = ring.cells[c];
        if (cell.positionOffsetChanged) {
          var offset = (r * board.numCells + c) * 24 * 3 * 4;
          var newData = new List.generate(24 * 3, (i) {
            switch (i % 3) {
              case 0:
                return cell.positionOffset.x;

              case 1:
                return cell.positionOffset.y;

              case 2:
                return cell.positionOffset.z;
            }
          });
          _glProgram.gl
            ..bindBuffer(webgl.ARRAY_BUFFER, _positionOffsetBuffer)
            ..bufferSubData(webgl.ARRAY_BUFFER, offset, new Float32List.fromList(newData));
        }
      }
    }

    _glProgram.gl
      ..bindBuffer(webgl.ARRAY_BUFFER, _positionBuffer)
      ..enableVertexAttribArray(_glProgram.positionAttrib)
      ..vertexAttribPointer(_glProgram.positionAttrib, 3, webgl.FLOAT, false, 0, 0);

    _glProgram.gl
      ..bindBuffer(webgl.ARRAY_BUFFER, _positionOffsetBuffer)
      ..enableVertexAttribArray(_glProgram.positionOffsetAttrib)
      ..vertexAttribPointer(_glProgram.positionOffsetAttrib, 3, webgl.FLOAT, false, 0, 0);

    _glProgram.gl
      ..bindBuffer(webgl.ARRAY_BUFFER, _normalBuffer)
      ..enableVertexAttribArray(_glProgram.normalAttrib)
      ..vertexAttribPointer(_glProgram.normalAttrib, 3, webgl.FLOAT, false, 0, 0);

    _glProgram.gl
      ..bindBuffer(webgl.ARRAY_BUFFER, _textureBuffer)
      ..enableVertexAttribArray(_glProgram.textureCoordAttrib)
      ..vertexAttribPointer(_glProgram.textureCoordAttrib, 2, webgl.FLOAT, false, 0, 0);

    _glProgram.gl
      ..bindBuffer(webgl.ELEMENT_ARRAY_BUFFER, _indexBuffer)
      ..drawElements(webgl.TRIANGLES, 36 * board.numRings * board.numCells, webgl.UNSIGNED_SHORT, 0);
  }
}