```metal
#include <metal_stdlib>
using namespace metal;

struct SpriteVertex {
    float2 position;
    float2 texCoord;
};

struct SpriteUniforms {
    float2 position;
    float2 size;
};

struct SpriteVertexOut {
    float4 position [[position]];
    float2 texCoord;
};

vertex SpriteVertexOut spriteVertex(
    uint vertexID [[vertex_id]],
    const device SpriteVertex *vertices [[buffer(0)]],
    constant SpriteUniforms &uniforms [[buffer(1)]]
) {
    SpriteVertexOut output;

    SpriteVertex currentVertex = vertices[vertexID];

    float2 finalPosition =
        currentVertex.position * uniforms.size
        + uniforms.position;

    output.position = float4(
        finalPosition,
        0.0,
        1.0
    );

    output.texCoord = currentVertex.texCoord;

    return output;
}

fragment float4 spriteFragment(
    SpriteVertexOut input [[stage_in]],
    texture2d<float> texture [[texture(0)]],
    sampler textureSampler [[sampler(0)]]
) {
    return texture.sample(
        textureSampler,
        input.texCoord
    );
}
```
