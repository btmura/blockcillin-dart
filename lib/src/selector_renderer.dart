part of blockcillin;

/// Renderer of the selector.
class SelectorRenderer {

  final webgl.RenderingContext _gl;
  final SelectorProgram _program;

  SelectorRenderer(this._gl, this._program);

  void render() {
    _program.useProgram();
  }
}