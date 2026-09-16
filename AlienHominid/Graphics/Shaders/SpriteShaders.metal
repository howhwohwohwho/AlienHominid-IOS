#include <metal_stdlib>
using namespace metal;

struct SpriteVertex {
    float2 position;
    float2 texCoord;
};

struct SpriteVertexOut {
    float4 position [[position]];
    float2 texCoord;
};

vertex SpriteVertexOut spriteVertex(
    uint vertexID [[vertex_id]],
    constant SpriteVertex *vertices [[buffer(0)]]
) {
    SpriteVertexOut out;

    SpriteVertex vertex = vertices[vertexID];

    out.position = float4(
        vertex.position,
        0.0,
        1.0
    );

    out.texCoord = vertex.texCoord;

    return out;
}

fragment float4 spriteFragment(
    SpriteVertexOut in [[stage_in]],
    texture2d<float> texture [[texture(0)]],
    sampler textureSampler [[sampler(0)]]
) {
    return texture.sample(
        textureSampler,
        in.texCoord
    );
}
