Shader "Custom/Explosion"
{
    Properties
    {
        
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
                float3 camRelativeWorldPos : TEXCOORD5;
                float3 positionWS : TEXCOORD6;
            };

            uniform sampler2D _CameraDepthTexture;

            Varyings vert(Attributes i)
            {
                Varyings o = (Varyings)0;

                o.baseColor = i.baseColor;
                o.rimColor = i.rimColor;

                o.normalWS = UnityObjectToWorldNormal(i.normalOS);

                o.positionWS = mul(unity_ObjectToWorld, i.positionOS).xyz;
                o.viewDir = normalize(_WorldSpaceCameraPos.xyz - o.positionWS);

                o.camRelativeWorldPos = o.positionWS - _WorldSpaceCameraPos;

                o.positionSS = ComputeScreenPos(i.positionOS);

                o.positionCS = UnityObjectToClipPos(i.positionOS);

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
                depth = Linear01Depth(depth);

                float depthDiff = saturate(1 - (depth - i.positionCS.z) * 0.1);

                float fresnel = Fresnel(i.normalWS, i.viewDir, 2);
                half4 col = i.baseColor + i.rimColor * fresnel + i.rimColor * depthDiff;

                return col;
            }

            ENDCG

        }
    }
}
