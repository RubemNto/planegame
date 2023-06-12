Shader "Custom/Smoke"
{
    Properties
    {
        _MainTex ("Albedo (RGB) Alpha (A)", 2D) = "white" {}
        _Density ("Density", Range(1, 100)) = 0.5
    }

    SubShader
    {
        Tags { "Queue" = "Transparent" "RenderType" = "Transparent" }

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows vertex:vert alpha:fade

        struct Input
        {
            float2 uv_MainTex;
            float3 lightDirTS;
            float4 color : COLOR;
        };

        float _Density;
        sampler2D _MainTex;

        void vert(inout appdata_full v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input, o);

            float3 normalWS = UnityObjectToWorldNormal(v.normal);
            float3 tangentWS = UnityObjectToWorldDir(v.tangent);
            float tangentSign = v.tangent.w * unity_WorldTransformParams.w;
            float3 bitangentWS = cross(normalWS, tangentWS) * tangentSign;
            o.lightDirTS = float3(
                dot(_WorldSpaceLightPos0.xyz, tangentWS),
                dot(_WorldSpaceLightPos0.xyz, bitangentWS),
                dot(_WorldSpaceLightPos0.xyz, normalWS)
            );
        }

        half3 RayMarch2D(sampler2D tex, float2 uv, float maxDist, float2 marchDir, int steps, half3 lightCol, float density)
        {
            float stepLength = maxDist / steps;
            float2 stepOffset = stepLength * marchDir;

            float transmittance = 1;
            for (int i = 0; i < steps; i++)
            {
                float deltaDensity = tex2D(tex, uv).a * density;

                transmittance *= exp(-deltaDensity * stepLength);

                uv += stepOffset;
            }

            return lightCol * transmittance;
        }

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            float2 uv = IN.uv_MainTex + float2(0, -_Time.y * 0.5);
            half3 volCol = RayMarch2D(_MainTex, uv, 0.05, IN.lightDirTS.xy, 5, _LightColor0.rgb, _Density);

            half4 col = tex2D(_MainTex, IN.uv_MainTex);
            half4 col02 = tex2D(_MainTex, uv);

            o.Albedo = volCol.rgb * IN.color.rgb;
            o.Alpha = col.r * col02.a * IN.color.a;
        }

        ENDCG
    }

    FallBack "Diffuse"
}
