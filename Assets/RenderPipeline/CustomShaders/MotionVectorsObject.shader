Shader "MotionVectorsObject" {
    HLSLINCLUDE
        #include "Assets/RenderPipeline/OwlcatShaders/ShaderLibrary/Core.hlsl"
        #include "Assets/RenderPipeline/OwlcatShaders/ShaderLibrary/Input.hlsl"
    ENDHLSL

    SubShader {
        Pass {
            ZWrite Off
            ZTest LEqual
                        
            HLSLPROGRAM
            #pragma vertex vertex
            #pragma fragment pixel

            float4x4 _PrevM;
            
            struct v2p {
                float4 _ : SV_POSITION; 
                float4 positionCS : TEXCOORD0;
                float4 prevPositionCS : TEXCOORD1;
            };

            // Helper function to check if matrix is identity
            bool IsIdentityMatrix(float4x4 mat) {
                return all(mat[0] == float4(1,0,0,0)) &&
                       all(mat[1] == float4(0,1,0,0)) &&
                       all(mat[2] == float4(0,0,1,0)) &&
                       all(mat[3] == float4(0,0,0,1));
            }


            v2p vertex(float4 position : POSITION) {
                v2p v2p;
                float4 clipPos = mul(UNITY_MATRIX_VP, mul(UNITY_MATRIX_M, position));
                float4 prevClipPos = mul(UNITY_MATRIX_VP, mul(_PrevM, position));
                v2p.positionCS = clipPos;
                v2p.prevPositionCS = prevClipPos;
                v2p._ = clipPos; // this is included because interpolation issues
                return v2p;
            }

            float2 pixel(v2p v2p) : SV_Target {
                if (IsIdentityMatrix(_PrevM)) {
                    discard;
                }

                float2 currentNDC = v2p.positionCS.xy / v2p.positionCS.w;
                float2 prevNDC = v2p.prevPositionCS.xy / v2p.prevPositionCS.w;
                float2 vel = currentNDC - prevNDC;

#if UNITY_UV_STARTS_AT_TOP
                vel.y = -vel.y;
#endif

                return vel;
            }

            ENDHLSL
        }
    }
}
