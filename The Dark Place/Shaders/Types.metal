#include <metal_stdlib>
using namespace metal;

struct VertexIn{
    float3 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
    float3 normal [[ attribute(2) ]];
    float2 textureCoordinate [[ attribute(3) ]];
};

struct RasterizerData {
    float4 position [[ position ]];
    float4 color;
    float3 surfaceNormal;
    float3 toCameraVector;
    float2 textureCoordinate;
    float3 worldPosition;
    float3 eyePosition;
    float3 skyColor;
};

struct ModelConstants{
    float4x4 modelMatrix;
    float3x3 normalMatrix;
};

struct SceneConstants {
    float3 skyColor;
    float4x4 viewMatrix;
    float4x4 projectionMatrix;
    float3 eyePosition;
    float4x4 inverseViewMatrix;
};

struct Material {
    float shininess;
    float3 ambient; //Ka
    float3 diffuse; //Kd
    float3 specular; //Ks
    bool isLit;
    float4 color;
};

struct LightData {
    float brightness;
    float3 position;
    float3 color;
    float3 attenuation;
};


