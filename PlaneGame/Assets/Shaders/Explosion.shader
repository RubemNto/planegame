Shader "Custom/Explosion"
{
    Properties
    {
        _DepthRange ("Depth Distance", Range(0.5, 5)) = 3
    }

    SubShader
    {
        Tags { "Queue" = "Transparent" }

        Pass 
        {

            CGPROGRAM

            #pragma vertex vert 
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS : NORMAL;

                half4 baseColor : TEXCOORD0;
                half4 rimColor : TEXCOORD1;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;

                half4 baseColor : TEXCOORD0;
                half4 rimColor : TEXCOORD1;
                float3 normalWS : TEXCOORD2;
                float3 viewDir : TEXCOORD3;
                float4 positionSS : TEXCOORD4;
                float3 positionWS : TEXCOORD5;
            };

            uniform sampler2D _CameraDepthTexture;

            float _DepthRange;

            Varyings vert(Attributes i)
            {
                Varyings o = (Varyings)0;

                o.baseColor = i.baseColor;
                o.rimColor = i.rimColor;

                o.normalWS = UnityObjectToWorldNormal(i.normalOS);

                o.positionWS = mul(unity_ObjectToWorld, i.positionOS).xyz;
                o.viewDir = normalize(_WorldSpaceCameraPos.xyz - o.positionWS);

                o.positionCS = UnityObjectToClipPos(i.positionOS);

                o.positionSS = ComputeScreenPos(o.positionCS);

                return o;
            }

            float Fresnel(float3 normal, float3 viewDir, float exponent)
            {
                return pow(saturate(1 - dot(normal, viewDir)), exponent);
            }

            half4 frag(Varyings i) : SV_TARGET
            {
                float2 screenUV = i.positionSS.xy / i.positionSS.w;

                float depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, screenUV);
                depth = LinearEyeDepth(depth);

                float depthDiff = saturate(1 - (depth - LinearEyeDepth(i.positionCS.z)) * _DepthRange);

                float fresnel = Fresnel(i.normalWS, i.viewDir, 2);
                half4 col = lerp(i.baseColor, i.rimColor, saturate(fresnel + depthDiff));

                return col;
            }

            ENDCG

        }
    }
}
