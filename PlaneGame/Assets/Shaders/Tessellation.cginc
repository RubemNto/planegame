#ifndef TESSELLATION_CGINC
#define TESSELLATION_CGINC

struct TessellationFactors
{
    float edge[3] : SV_TessFactor;
    float inside : SV_InsideTessFactor;
};

struct TessellationControlPoint
{
    float4 positionOS : INTERNALTESSPOS;
    float3 normalOS : NORMAL;

    float2 uv : TEXCOORD0;
    float4 color : TEXCOORD1;
};

float _TessellationUniform;

TessellationControlPoint tessellationVert(Attributes i)
{
    TessellationControlPoint o;
    o.positionOS = i.positionOS;
    o.normalOS = i.normalOS;
    o.uv = i.uv;
    o.color = i.color;
    return o;
}

TessellationFactors PatchConstantFunction(InputPatch<TessellationControlPoint, 3> patch)
{
    float3 p0 = mul(unity_ObjectToWorld, patch[0].positionOS).xyz;
    float3 p1 = mul(unity_ObjectToWorld, patch[1].positionOS).xyz;
    float3 p2 = mul(unity_ObjectToWorld, patch[2].positionOS).xyz;

    TessellationFactors f;
    f.edge[0] = _TessellationUniform;
    f.edge[1] = _TessellationUniform;
    f.edge[2] = _TessellationUniform;
    f.inside = _TessellationUniform;

    return f;
}

[UNITY_domain("tri")]
[UNITY_outputcontrolpoints(3)]
[UNITY_outputtopology("triangle_cw")]
[UNITY_partitioning("fractional_odd")]
[UNITY_patchconstantfunc("PatchConstantFunction")]
TessellationControlPoint hull(InputPatch<TessellationControlPoint, 3> patch, uint id : SV_OutputControlPointID)
{
    return patch[id];
}

[UNITY_domain("tri")]
Varyings domain(TessellationFactors factors, OutputPatch<TessellationControlPoint, 3> patch, float3 barycentricCoords : SV_DomainLocation)
{
    Attributes data;

    #define DOMAIN_INTERPOLATE(fieldName) data.fieldName = \
        patch[0].fieldName * barycentricCoords.x + \
        patch[1].fieldName * barycentricCoords.y + \
        patch[2].fieldName * barycentricCoords.z;

    DOMAIN_INTERPOLATE(positionOS);
    DOMAIN_INTERPOLATE(normalOS);
    DOMAIN_INTERPOLATE(uv);
    DOMAIN_INTERPOLATE(color);

    return vert(data);
}

#endif