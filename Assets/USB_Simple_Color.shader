Shader "USB/USB_Simple_Color"
{
    Properties
    {
        // Properties in here
        _MainTex ("Main Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)

        [Toggle] _Enable ("Enable ?", Float) = 1
    }
    SubShader
    {
        // Subshader configuration here
        Tags { "RenderType"="Opaque"  "Queue" = "Geometry"}
        LOD 100

        Pass
        {
            CGPROGRAM
            // program Cg - HLSL in here
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #pragma shader_feature _ENABLE_ON

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

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;

            float4 ourFunction(){
                    return float4(1,1,1,1);
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                half4 col = tex2D(_MainTex, i.uv);
            
            #if _ENABLE_ON
                return col * _Color;
            #else
                return col ;
            #endif
                // float4 f = ourFunction();
                // return f;
            }
            ENDCG
        }
    }
}
