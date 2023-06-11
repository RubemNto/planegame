Shader "Hidden/ColorBlindness"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        [Toggle] _Normal ("       Normal", Int) = 0
        [Toggle] _Achromatopsia ("Achromatopsia", Int) = 0
        [Toggle] _Tritanopia ("   Tritanopia", Int) = 0
        [Toggle] _Pratanopia ("   Pratanopia", Int) = 0
        [Toggle] _Deuteranopia (" Deuteranopia", Int) = 0
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;

            int _Normal;
            int _Achromatopsia;
            int _Tritanopia;
            int _Pratanopia;
            int _Deuteranopia;

            // fixed3 lRGB_2_XYZ(fixed3 lRGB)
            // {
            //     float3x3 mat = float3x3(
            //         0.4124564, 0.3575761, 0.1804375,
            //         0.2126729, 0.7151522, 0.0721750,
            //         0.0193339, 0.1191920, 0.9503041
            //     );
            //     return mul(mat,lRGB);
            // }

            // fixed3 XYZ_2_LMS(fixed3 XYZ)
            // {
            //     float3x3 mat = float3x3(
            //         0.4002, 0.7076, -0.0808,
            //         -0.2263, 1.1653, 0.0457,
            //         0, 0, 0.9182
            //     );
            //     return mul(mat,XYZ);
            // }

            // fixed3 Transformed_LMS(fixed3 LMS, float3x3 transformationMatrix)
            // {
            //     return mul(transformationMatrix,LMS);
            // }

            // fixed3 LMS_2_XYZ(fixed3 LMS)
            // {
            //     float3x3 mat = float3x3(
            //         1.8600666, -1.1294801, 0.2198983,
            //         0.3612229, 0.6388043, 0,
            //         0, 0, 1.089087
            //     );
            //     return mul(mat,LMS);
            // }

            // fixed3 XYZ_2_lRGB(fixed3 XYZ)
            // {
            //     float3x3 mat = float3x3(
            //         3.24045484, -1.5371389, -0.49853155,
            //         -0.96926639, 1.8760109, 0.04155608,
            //         0.05564342, -0.2040259, 1.05722516
            //     );
            //     return mul(mat,XYZ);
            // }

            fixed4 Normal (fixed4 col){
                return col;
            }

            fixed4 Achromatopsia (fixed4 col){
                //Traditional grayscale
                // return (col.r + col.g + col.b)/3.0;

                //https://en.wikipedia.org/wiki/Grayscale#Colorimetric_.28luminance-preserving.29_conversion_to_grayscale
                float a = (0.02126*col.r+0.7152*col.g+0.0722*col.b);
                return float4(a,a,a,1);
            }

            fixed4 Tritanopia (fixed4 col){

                float3x3 mat = float3x3(
                    1, 0.1273989 , -0.1273989,
                    0, 0.8739093 , 0.1260907,
                    0, 0.8739093 , 0.1260907
                );
                fixed3 ncol = mul(mat,float3(col.r,col.g,col.b));
                return float4(ncol.r,ncol.g,ncol.b,1);
            }

            fixed4 Protanopia (fixed4 col){

                float3x3 mat = float3x3(
                    0.170556992, 0.829443014, 0,
                    0.170556991, 0.829443008, 0,
                    0.004517144, 0.004517144, 1
                );
                fixed3 ncol = mul(mat,float3(col.r,col.g,col.b));
                return float4(ncol.r,ncol.g,ncol.b,1);
            }
            
            fixed4 Deuteranopia (fixed4 col){
                float3x3 mat = float3x3(
                    0.33066007,0.66933993,0,
                    0.33066007,0.66933993,0,
                    -0.02785538,0.02785538,1
                );
                fixed3 ncol = mul(mat,float3(col.r,col.g,col.b));
                return float4(ncol.r,ncol.g,ncol.b,1);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

                if(_Normal){
                    return Normal(col);
                }

                if(_Achromatopsia){
                    return Achromatopsia(col);
                }
                
                if(_Tritanopia){
                    return Tritanopia(col);
                }

                if(_Pratanopia){
                    return Protanopia(col);
                }

                if(_Deuteranopia){
                    return Deuteranopia(col);
                }

                return col;
            }
            ENDCG
        }
    }
}
