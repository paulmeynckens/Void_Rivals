Shader "Toon"
{
    Properties
    {
        _MainColor("Tint", Color) = (1, 1, 1, 0)
        [NoScaleOffset]_MainTexture("Color Texture", 2D) = "white" {}
        _Smoothness("Smoothness", Range(0, 1)) = 0.5
        _SpecularColor("Specular Color", Color) = (0, 0, 0, 0)
        [NoScaleOffset]_SpecularMap("Specular Map", 2D) = "white" {}
        _OutlineThickness("Outline Thickness", Float) = 1
        _OutlineDepthSensitivity("Depth Sensitivity", Range(0, 1)) = 1
        _OutlineNormalsSensitivity("Normals Sensitivity", Range(0, 1)) = 1
        _Tiling("Tiling", Vector) = (1, 1, 0, 0)
        _Offset("Offset", Vector) = (0, 0, 0, 0)
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
        [Toggle]LIGHTMAP("LIGHTMAP", Float) = 0

        [Header(Stencil Masking)]
        _StencilRef("_StencilRef", Float) = 0
        [Enum(UnityEngine.Rendering.CompareFunction)]_StencilComp("_StencilComp (default = Disable)", Float) = 0 //0 = disable
        [Enum(UnityEngine.Rendering.StencilOp)]_StencilOp("_StencilOp (default = Disable)", Float) = 0 //0 = disable
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Opaque"
            "UniversalMaterialType" = "Unlit"
            "Queue"="AlphaTest"
        }

        Pass
        {
            Name "Pass"
            Tags
            {
                // LightMode: <None>
            }

            Stencil
            {
                Ref[_StencilRef]
                Comp[_StencilComp]
                Pass[_StencilOp]
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma shader_feature _ _SAMPLE_GI
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
        #pragma multi_compile _ _SHADOWS_SOFT
        #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile _ LIGHTMAP_ON

        #if defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_1
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_2
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT)
            #define KEYWORD_PERMUTATION_3
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_4
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_5
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_6
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE)
            #define KEYWORD_PERMUTATION_7
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_8
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_9
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_SHADOWS_SOFT) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_10
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_SHADOWS_SOFT)
            #define KEYWORD_PERMUTATION_11
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_12
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_13
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_14
        #elif defined(_MAIN_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_15
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_16
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_17
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_18
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT)
            #define KEYWORD_PERMUTATION_19
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_20
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_21
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_22
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE)
            #define KEYWORD_PERMUTATION_23
        #elif defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_24
        #elif defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_25
        #elif defined(_SHADOWS_SOFT) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_26
        #elif defined(_SHADOWS_SOFT)
            #define KEYWORD_PERMUTATION_27
        #elif defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_28
        #elif defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_29
        #elif defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_30
        #else
            #define KEYWORD_PERMUTATION_31
        #endif


            // Defines
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define _AlphaClip 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define ATTRIBUTES_NEED_NORMAL
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define ATTRIBUTES_NEED_TANGENT
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define ATTRIBUTES_NEED_TEXCOORD2
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define VARYINGS_NEED_POSITION_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define VARYINGS_NEED_NORMAL_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define VARYINGS_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define VARYINGS_NEED_TEXCOORD1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define VARYINGS_NEED_TEXCOORD2
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #endif

            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_UNLIT
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 uv1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 uv2 : TEXCOORD2;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 texCoord0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 texCoord1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 texCoord2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 viewDirectionWS;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 WorldSpaceViewDirection;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 WorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 AbsoluteWorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 ScreenPosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 uv1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 uv2;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 interp0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 interp1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 interp2 : TEXCOORD2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 interp3 : TEXCOORD3;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 interp4 : TEXCOORD4;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 interp5 : TEXCOORD5;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };

            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.texCoord0;
            output.interp3.xyzw =  input.texCoord1;
            output.interp4.xyzw =  input.texCoord2;
            output.interp5.xyz =  input.viewDirectionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.texCoord0 = input.interp2.xyzw;
            output.texCoord1 = input.interp3.xyzw;
            output.texCoord2 = input.interp4.xyzw;
            output.viewDirectionWS = input.interp5.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _MainColor;
        float4 _MainTexture_TexelSize;
        float _Smoothness;
        float4 _SpecularColor;
        float4 _SpecularMap_TexelSize;
        float _OutlineThickness;
        float _OutlineDepthSensitivity;
        float _OutlineNormalsSensitivity;
        float2 _Tiling;
        float2 _Offset;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTexture);
        SAMPLER(sampler_MainTexture);
        TEXTURE2D(_SpecularMap);
        SAMPLER(sampler_SpecularMap);

            // Graph Functions
            
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        struct Bindings_Albedo_e5a8c819ad3623244a943a45dac4ffa4
        {
            half4 uv0;
        };

        void SG_Albedo_e5a8c819ad3623244a943a45dac4ffa4(float4 Vector4_12A72EFC, UnityTexture2D Texture2D_9644D008, float2 Vector2_E2350C2, float2 Vector2_D0710BCD, Bindings_Albedo_e5a8c819ad3623244a943a45dac4ffa4 IN, out float4 AlbedoTransp_1)
        {
            float4 _Property_ead5a42fe40ddf8890ef8f59627dbf00_Out_0 = Vector4_12A72EFC;
            float _Split_eefb1b94fc79aa81969b28152339aaa5_R_1 = _Property_ead5a42fe40ddf8890ef8f59627dbf00_Out_0[0];
            float _Split_eefb1b94fc79aa81969b28152339aaa5_G_2 = _Property_ead5a42fe40ddf8890ef8f59627dbf00_Out_0[1];
            float _Split_eefb1b94fc79aa81969b28152339aaa5_B_3 = _Property_ead5a42fe40ddf8890ef8f59627dbf00_Out_0[2];
            float _Split_eefb1b94fc79aa81969b28152339aaa5_A_4 = _Property_ead5a42fe40ddf8890ef8f59627dbf00_Out_0[3];
            float4 _Combine_0989ac05ac713585b1970bd9dce2d35a_RGBA_4;
            float3 _Combine_0989ac05ac713585b1970bd9dce2d35a_RGB_5;
            float2 _Combine_0989ac05ac713585b1970bd9dce2d35a_RG_6;
            Unity_Combine_float(_Split_eefb1b94fc79aa81969b28152339aaa5_R_1, _Split_eefb1b94fc79aa81969b28152339aaa5_G_2, _Split_eefb1b94fc79aa81969b28152339aaa5_B_3, 1, _Combine_0989ac05ac713585b1970bd9dce2d35a_RGBA_4, _Combine_0989ac05ac713585b1970bd9dce2d35a_RGB_5, _Combine_0989ac05ac713585b1970bd9dce2d35a_RG_6);
            UnityTexture2D _Property_c6a26ce271d98f84bb13cd7ce0ae398d_Out_0 = Texture2D_9644D008;
            float2 _Property_fe6e35ca6b347f83a931216e0b119ec0_Out_0 = Vector2_E2350C2;
            float2 _Property_422e593a494f798fbe504a4f2b01c59a_Out_0 = Vector2_D0710BCD;
            float2 _TilingAndOffset_7708bc2bff71f48e91e0337bac4a6137_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_fe6e35ca6b347f83a931216e0b119ec0_Out_0, _Property_422e593a494f798fbe504a4f2b01c59a_Out_0, _TilingAndOffset_7708bc2bff71f48e91e0337bac4a6137_Out_3);
            float4 _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c6a26ce271d98f84bb13cd7ce0ae398d_Out_0.tex, _Property_c6a26ce271d98f84bb13cd7ce0ae398d_Out_0.samplerstate, _TilingAndOffset_7708bc2bff71f48e91e0337bac4a6137_Out_3);
            float _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_R_4 = _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0.r;
            float _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_G_5 = _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0.g;
            float _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_B_6 = _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0.b;
            float _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_A_7 = _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0.a;
            float4 _Multiply_2bed8dfc9ac182839f4890b363090fbe_Out_2;
            Unity_Multiply_float(_Combine_0989ac05ac713585b1970bd9dce2d35a_RGBA_4, _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0, _Multiply_2bed8dfc9ac182839f4890b363090fbe_Out_2);
            AlbedoTransp_1 = _Multiply_2bed8dfc9ac182839f4890b363090fbe_Out_2;
        }

        // c3db79911ce3b41a0f2b2d6cf4a329f9
        #include "Assets/Shaders/CustomHLSL/CustomLighting.hlsl"

        struct Bindings_AdditionalLights_1b03813eb6f91994b841c8e22a1e1806
        {
            float3 WorldSpaceNormal;
            float3 WorldSpaceViewDirection;
            float3 WorldSpacePosition;
        };

        void SG_AdditionalLights_1b03813eb6f91994b841c8e22a1e1806(float Vector1_E56B297F, Bindings_AdditionalLights_1b03813eb6f91994b841c8e22a1e1806 IN, out float3 LightDiffuse_1, out float3 Specular_2)
        {
            float _Property_0c14249b5acf138c9865bbe708691426_Out_0 = Vector1_E56B297F;
            float3 _AdditionalLightsCustomFunction_6fd8cab1f3391f89b26a5e7454672aa1_Diffuse_1;
            float3 _AdditionalLightsCustomFunction_6fd8cab1f3391f89b26a5e7454672aa1_Specular_2;
            AdditionalLights_float(_Property_0c14249b5acf138c9865bbe708691426_Out_0, IN.WorldSpacePosition, IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _AdditionalLightsCustomFunction_6fd8cab1f3391f89b26a5e7454672aa1_Diffuse_1, _AdditionalLightsCustomFunction_6fd8cab1f3391f89b26a5e7454672aa1_Specular_2);
            LightDiffuse_1 = _AdditionalLightsCustomFunction_6fd8cab1f3391f89b26a5e7454672aa1_Diffuse_1;
            Specular_2 = _AdditionalLightsCustomFunction_6fd8cab1f3391f89b26a5e7454672aa1_Specular_2;
        }

        void Unity_ColorspaceConversion_RGB_HSV_float(float3 In, out float3 Out)
        {
            float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
            float4 P = lerp(float4(In.bg, K.wz), float4(In.gb, K.xy), step(In.b, In.g));
            float4 Q = lerp(float4(P.xyw, In.r), float4(In.r, P.yzx), step(P.x, In.r));
            float D = Q.x - min(Q.w, Q.y);
            float  E = 1e-10;
            Out = float3(abs(Q.z + (Q.w - Q.y)/(6.0 * D + E)), D / (Q.x + E), Q.x);
        }

        void Unity_SampleGradientV0_float(Gradient Gradient, float Time, out float4 Out)
        {
            float3 color = Gradient.colors[0].rgb;
            [unroll]
            for (int c = 1; c < 8; c++)
            {
                float colorPos = saturate((Time - Gradient.colors[c - 1].w) / (Gradient.colors[c].w - Gradient.colors[c - 1].w)) * step(c, Gradient.colorsLength - 1);
                color = lerp(color, Gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), Gradient.type));
            }
        #ifndef UNITY_COLORSPACE_GAMMA
            color = SRGBToLinear(color);
        #endif
            float alpha = Gradient.alphas[0].x;
            [unroll]
            for (int a = 1; a < 8; a++)
            {
                float alphaPos = saturate((Time - Gradient.alphas[a - 1].y) / (Gradient.alphas[a].y - Gradient.alphas[a - 1].y)) * step(a, Gradient.alphasLength - 1);
                alpha = lerp(alpha, Gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), Gradient.type));
            }
            Out = float4(color, alpha);
        }

        void Unity_ColorspaceConversion_HSV_RGB_float(float3 In, out float3 Out)
        {
            float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
            float3 P = abs(frac(In.xxx + K.xyz) * 6.0 - K.www);
            Out = In.z * lerp(K.xxx, saturate(P - K.xxx), In.y);
        }

        void Unity_Step_float3(float3 Edge, float3 In, out float3 Out)
        {
            Out = step(Edge, In);
        }

        struct Bindings_AdditionalLightsToon_87dc85b7edc8a8442adaa8215da4c975
        {
            float3 WorldSpaceNormal;
            float3 WorldSpaceViewDirection;
            float3 WorldSpacePosition;
        };

        void SG_AdditionalLightsToon_87dc85b7edc8a8442adaa8215da4c975(float Vector1_5CCA1F29, Bindings_AdditionalLightsToon_87dc85b7edc8a8442adaa8215da4c975 IN, out float4 Lighting_1, out float Specular_2)
        {
            float _Property_a0bf9a7225753688bc2d1fd921f6d2cc_Out_0 = Vector1_5CCA1F29;
            Bindings_AdditionalLights_1b03813eb6f91994b841c8e22a1e1806 _AdditionalLights_53ace4769a03878cab4dfc8713da150a;
            _AdditionalLights_53ace4769a03878cab4dfc8713da150a.WorldSpaceNormal = IN.WorldSpaceNormal;
            _AdditionalLights_53ace4769a03878cab4dfc8713da150a.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
            _AdditionalLights_53ace4769a03878cab4dfc8713da150a.WorldSpacePosition = IN.WorldSpacePosition;
            float3 _AdditionalLights_53ace4769a03878cab4dfc8713da150a_LightDiffuse_1;
            float3 _AdditionalLights_53ace4769a03878cab4dfc8713da150a_Specular_2;
            SG_AdditionalLights_1b03813eb6f91994b841c8e22a1e1806(_Property_a0bf9a7225753688bc2d1fd921f6d2cc_Out_0, _AdditionalLights_53ace4769a03878cab4dfc8713da150a, _AdditionalLights_53ace4769a03878cab4dfc8713da150a_LightDiffuse_1, _AdditionalLights_53ace4769a03878cab4dfc8713da150a_Specular_2);
            float3 _ColorspaceConversion_094f58e30f03a482b38d714f1b72fe2d_Out_1;
            Unity_ColorspaceConversion_RGB_HSV_float(_AdditionalLights_53ace4769a03878cab4dfc8713da150a_LightDiffuse_1, _ColorspaceConversion_094f58e30f03a482b38d714f1b72fe2d_Out_1);
            float _Split_6a230abe7aa3cf818eee9b8259b924d5_R_1 = _ColorspaceConversion_094f58e30f03a482b38d714f1b72fe2d_Out_1[0];
            float _Split_6a230abe7aa3cf818eee9b8259b924d5_G_2 = _ColorspaceConversion_094f58e30f03a482b38d714f1b72fe2d_Out_1[1];
            float _Split_6a230abe7aa3cf818eee9b8259b924d5_B_3 = _ColorspaceConversion_094f58e30f03a482b38d714f1b72fe2d_Out_1[2];
            float _Split_6a230abe7aa3cf818eee9b8259b924d5_A_4 = 0;
            float4 _SampleGradient_31f89c9bf504f98e80e170e89328bcd5_Out_2;
            Unity_SampleGradientV0_float(NewGradient(1, 4, 2, float4(0, 0, 0, 0.001586938),float4(0.4339623, 0.4339623, 0.4339623, 0.2507973),float4(0.9056604, 0.9056604, 0.9056604, 0.317464),float4(1, 1, 1, 1),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0), float2(1, 0),float2(1, 1),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0)), _Split_6a230abe7aa3cf818eee9b8259b924d5_B_3, _SampleGradient_31f89c9bf504f98e80e170e89328bcd5_Out_2);
            float4 _Combine_d2b3f1197a27e889b1a337872c3276c5_RGBA_4;
            float3 _Combine_d2b3f1197a27e889b1a337872c3276c5_RGB_5;
            float2 _Combine_d2b3f1197a27e889b1a337872c3276c5_RG_6;
            Unity_Combine_float(_Split_6a230abe7aa3cf818eee9b8259b924d5_R_1, _Split_6a230abe7aa3cf818eee9b8259b924d5_G_2, (_SampleGradient_31f89c9bf504f98e80e170e89328bcd5_Out_2).x, 0, _Combine_d2b3f1197a27e889b1a337872c3276c5_RGBA_4, _Combine_d2b3f1197a27e889b1a337872c3276c5_RGB_5, _Combine_d2b3f1197a27e889b1a337872c3276c5_RG_6);
            float3 _ColorspaceConversion_3f2a3d424d0a9f88b24bbb224398188a_Out_1;
            Unity_ColorspaceConversion_HSV_RGB_float(_Combine_d2b3f1197a27e889b1a337872c3276c5_RGB_5, _ColorspaceConversion_3f2a3d424d0a9f88b24bbb224398188a_Out_1);
            float _Float_f19702ba0b98e5888235471ae5bbcb7a_Out_0 = 0.5;
            float3 _Step_88136ba2548b628faf27c254f446e6b1_Out_2;
            Unity_Step_float3((_Float_f19702ba0b98e5888235471ae5bbcb7a_Out_0.xxx), _AdditionalLights_53ace4769a03878cab4dfc8713da150a_Specular_2, _Step_88136ba2548b628faf27c254f446e6b1_Out_2);
            Lighting_1 = (float4(_ColorspaceConversion_3f2a3d424d0a9f88b24bbb224398188a_Out_1, 1.0));
            Specular_2 = (_Step_88136ba2548b628faf27c254f446e6b1_Out_2).x;
        }

        void Unity_BakedGIScale_float(float3 Normal, out float3 Out, float3 Position, float2 StaticUV, float2 DynamicUV)
        {
            Out = SHADERGRAPH_BAKED_GI(Position, Normal, StaticUV, DynamicUV, true);
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Preview_float3(float3 In, out float3 Out)
        {
            Out = In;
        }

        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }

        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }

        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }

        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }

        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }

        struct Bindings_MainLight_231093b74d3ab1341aa61c0ebb5d779d
        {
            float3 WorldSpaceNormal;
            float3 AbsoluteWorldSpacePosition;
        };

        void SG_MainLight_231093b74d3ab1341aa61c0ebb5d779d(Bindings_MainLight_231093b74d3ab1341aa61c0ebb5d779d IN, out float3 Direction_5, out float3 Color_1, out float ShadowAttenuation_2, out float SelfShadowing_3)
        {
            float3 _MainLightCustomFunction_99d870f0ed063d869021050fbb0ee9d1_Direction_1;
            float3 _MainLightCustomFunction_99d870f0ed063d869021050fbb0ee9d1_Color_2;
            float _MainLightCustomFunction_99d870f0ed063d869021050fbb0ee9d1_ShadowAtten_4;
            MainLight_float(IN.AbsoluteWorldSpacePosition, _MainLightCustomFunction_99d870f0ed063d869021050fbb0ee9d1_Direction_1, _MainLightCustomFunction_99d870f0ed063d869021050fbb0ee9d1_Color_2, _MainLightCustomFunction_99d870f0ed063d869021050fbb0ee9d1_ShadowAtten_4);
            float _DotProduct_bfdcc1a1ade4b288b1499497b4259bb3_Out_2;
            Unity_DotProduct_float3(_MainLightCustomFunction_99d870f0ed063d869021050fbb0ee9d1_Direction_1, IN.WorldSpaceNormal, _DotProduct_bfdcc1a1ade4b288b1499497b4259bb3_Out_2);
            float _Clamp_ff09e84cb5001e8cb35cb21d0f2584d0_Out_3;
            Unity_Clamp_float(_DotProduct_bfdcc1a1ade4b288b1499497b4259bb3_Out_2, 0, 1, _Clamp_ff09e84cb5001e8cb35cb21d0f2584d0_Out_3);
            Direction_5 = _MainLightCustomFunction_99d870f0ed063d869021050fbb0ee9d1_Direction_1;
            Color_1 = _MainLightCustomFunction_99d870f0ed063d869021050fbb0ee9d1_Color_2;
            ShadowAttenuation_2 = _MainLightCustomFunction_99d870f0ed063d869021050fbb0ee9d1_ShadowAtten_4;
            SelfShadowing_3 = _Clamp_ff09e84cb5001e8cb35cb21d0f2584d0_Out_3;
        }

        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }

        void Unity_Saturate_float4(float4 In, out float4 Out)
        {
            Out = saturate(In);
        }

        void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }

        void Unity_OneMinus_float3(float3 In, out float3 Out)
        {
            Out = 1 - In;
        }

        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }

        struct Bindings_ToonLightingModel_2146d4f705c217e489ca16fbb84d44d9
        {
            float3 WorldSpaceNormal;
            float3 WorldSpaceViewDirection;
            float3 WorldSpacePosition;
            float3 AbsoluteWorldSpacePosition;
            half4 uv1;
            half4 uv2;
        };

        void SG_ToonLightingModel_2146d4f705c217e489ca16fbb84d44d9(float Vector1_A5B15C15, Gradient Gradient, Bindings_ToonLightingModel_2146d4f705c217e489ca16fbb84d44d9 IN, out float3 LightingModel_1, out float3 DirectSpecular_2)
        {
            float3 _BakedGI_2fc8dd439fd7af858bca45c02f8205e5_Out_1;
            Unity_BakedGIScale_float(IN.WorldSpaceNormal, _BakedGI_2fc8dd439fd7af858bca45c02f8205e5_Out_1, IN.WorldSpacePosition, IN.uv1.xy, IN.uv2.xy);
            float3 _ColorspaceConversion_39b5e9ab1a693f8a8b5f8780b4557a5a_Out_1;
            Unity_ColorspaceConversion_RGB_HSV_float(_BakedGI_2fc8dd439fd7af858bca45c02f8205e5_Out_1, _ColorspaceConversion_39b5e9ab1a693f8a8b5f8780b4557a5a_Out_1);
            float _Split_17c82c905153718a82c3e81547a16132_R_1 = _ColorspaceConversion_39b5e9ab1a693f8a8b5f8780b4557a5a_Out_1[0];
            float _Split_17c82c905153718a82c3e81547a16132_G_2 = _ColorspaceConversion_39b5e9ab1a693f8a8b5f8780b4557a5a_Out_1[1];
            float _Split_17c82c905153718a82c3e81547a16132_B_3 = _ColorspaceConversion_39b5e9ab1a693f8a8b5f8780b4557a5a_Out_1[2];
            float _Split_17c82c905153718a82c3e81547a16132_A_4 = 0;
            float _Multiply_bb5fe1db3b24d58a930c409b314e8a1f_Out_2;
            Unity_Multiply_float(_Split_17c82c905153718a82c3e81547a16132_G_2, 0.8, _Multiply_bb5fe1db3b24d58a930c409b314e8a1f_Out_2);
            float4 _SampleGradient_0c59798543f6bb8391877046be0e8d38_Out_2;
            Unity_SampleGradientV0_float(NewGradient(0, 6, 2, float4(0.4245283, 0.4245283, 0.4245283, 0.02697795),float4(0.7169812, 0.7169812, 0.7169812, 0.1190509),float4(0.8, 0.8, 0.8, 0.1269856),float4(0.8, 0.8, 0.8, 0.4682536),float4(0.9339623, 0.9339623, 0.9339623, 0.482536),float4(1, 1, 1, 1),float4(0, 0, 0, 0),float4(0, 0, 0, 0), float2(1, 0),float2(1, 1),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0)), _Split_17c82c905153718a82c3e81547a16132_B_3, _SampleGradient_0c59798543f6bb8391877046be0e8d38_Out_2);
            float4 _Combine_f113b1ff984e6881bf4ea01c8f163f89_RGBA_4;
            float3 _Combine_f113b1ff984e6881bf4ea01c8f163f89_RGB_5;
            float2 _Combine_f113b1ff984e6881bf4ea01c8f163f89_RG_6;
            Unity_Combine_float(_Split_17c82c905153718a82c3e81547a16132_R_1, _Multiply_bb5fe1db3b24d58a930c409b314e8a1f_Out_2, (_SampleGradient_0c59798543f6bb8391877046be0e8d38_Out_2).x, 0, _Combine_f113b1ff984e6881bf4ea01c8f163f89_RGBA_4, _Combine_f113b1ff984e6881bf4ea01c8f163f89_RGB_5, _Combine_f113b1ff984e6881bf4ea01c8f163f89_RG_6);
            float3 _ColorspaceConversion_490f3af98e415f81986bac1bfa502488_Out_1;
            Unity_ColorspaceConversion_HSV_RGB_float(_Combine_f113b1ff984e6881bf4ea01c8f163f89_RGB_5, _ColorspaceConversion_490f3af98e415f81986bac1bfa502488_Out_1);
            float3 _Preview_c84d707aa5b6f789b87f63c48f13d20c_Out_1;
            Unity_Preview_float3(_ColorspaceConversion_490f3af98e415f81986bac1bfa502488_Out_1, _Preview_c84d707aa5b6f789b87f63c48f13d20c_Out_1);
            float _Distance_188c26489abaaa848b60159cd31736e6_Out_2;
            Unity_Distance_float3(_WorldSpaceCameraPos, IN.WorldSpacePosition, _Distance_188c26489abaaa848b60159cd31736e6_Out_2);
            float _Remap_456561369c4c1a8fa18a3a3f0e29fccb_Out_3;
            Unity_Remap_float(_Distance_188c26489abaaa848b60159cd31736e6_Out_2, float2 (20, 40), float2 (0, 1), _Remap_456561369c4c1a8fa18a3a3f0e29fccb_Out_3);
            float _Saturate_1e9bf8e2d2668a8295317d40dd582163_Out_1;
            Unity_Saturate_float(_Remap_456561369c4c1a8fa18a3a3f0e29fccb_Out_3, _Saturate_1e9bf8e2d2668a8295317d40dd582163_Out_1);
            Bindings_MainLight_231093b74d3ab1341aa61c0ebb5d779d _MainLight_2184fb120acd0b8bb1e6400cf2362966;
            _MainLight_2184fb120acd0b8bb1e6400cf2362966.WorldSpaceNormal = IN.WorldSpaceNormal;
            _MainLight_2184fb120acd0b8bb1e6400cf2362966.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            float3 _MainLight_2184fb120acd0b8bb1e6400cf2362966_Direction_5;
            float3 _MainLight_2184fb120acd0b8bb1e6400cf2362966_Color_1;
            float _MainLight_2184fb120acd0b8bb1e6400cf2362966_ShadowAttenuation_2;
            float _MainLight_2184fb120acd0b8bb1e6400cf2362966_SelfShadowing_3;
            SG_MainLight_231093b74d3ab1341aa61c0ebb5d779d(_MainLight_2184fb120acd0b8bb1e6400cf2362966, _MainLight_2184fb120acd0b8bb1e6400cf2362966_Direction_5, _MainLight_2184fb120acd0b8bb1e6400cf2362966_Color_1, _MainLight_2184fb120acd0b8bb1e6400cf2362966_ShadowAttenuation_2, _MainLight_2184fb120acd0b8bb1e6400cf2362966_SelfShadowing_3);
            float4 _SampleGradient_5e6f35a9f2bba886a09e3496a4971514_Out_2;
            Unity_SampleGradientV0_float(NewGradient(0, 2, 2, float4(0, 0, 0, 0.4117647),float4(1, 1, 1, 0.4529488),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0), float2(1, 0),float2(1, 1),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0)), _MainLight_2184fb120acd0b8bb1e6400cf2362966_ShadowAttenuation_2, _SampleGradient_5e6f35a9f2bba886a09e3496a4971514_Out_2);
            float4 _Add_1e98a3cd04cd39849e42734903bddba4_Out_2;
            Unity_Add_float4((_Saturate_1e9bf8e2d2668a8295317d40dd582163_Out_1.xxxx), _SampleGradient_5e6f35a9f2bba886a09e3496a4971514_Out_2, _Add_1e98a3cd04cd39849e42734903bddba4_Out_2);
            float4 _Saturate_3240b551a6d8b8869728be4cfdbe59ba_Out_1;
            Unity_Saturate_float4(_Add_1e98a3cd04cd39849e42734903bddba4_Out_2, _Saturate_3240b551a6d8b8869728be4cfdbe59ba_Out_1);
            float3 _Multiply_c83a20123005fe86956bbdd635820916_Out_2;
            Unity_Multiply_float(_Preview_c84d707aa5b6f789b87f63c48f13d20c_Out_1, (_Saturate_3240b551a6d8b8869728be4cfdbe59ba_Out_1.xyz), _Multiply_c83a20123005fe86956bbdd635820916_Out_2);
            float _Multiply_8a1616c99027a08c89dbe6ee9431dff8_Out_2;
            Unity_Multiply_float(_MainLight_2184fb120acd0b8bb1e6400cf2362966_ShadowAttenuation_2, _MainLight_2184fb120acd0b8bb1e6400cf2362966_SelfShadowing_3, _Multiply_8a1616c99027a08c89dbe6ee9431dff8_Out_2);
            float4 _SampleGradient_b3c4fcbeaf5fbc8faf3b3e3c9a817008_Out_2;
            Unity_SampleGradientV0_float(NewGradient(0, 3, 2, float4(0.6037736, 0.6037736, 0.6037736, 0.4588235),float4(1, 1, 1, 0.4952316),float4(1, 1, 1, 1),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0), float2(1, 0),float2(1, 1),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0)), _Multiply_8a1616c99027a08c89dbe6ee9431dff8_Out_2, _SampleGradient_b3c4fcbeaf5fbc8faf3b3e3c9a817008_Out_2);
            float3 _Multiply_128d1fd95c401d8b899cab5f1390d224_Out_2;
            Unity_Multiply_float(_MainLight_2184fb120acd0b8bb1e6400cf2362966_Color_1, (_SampleGradient_b3c4fcbeaf5fbc8faf3b3e3c9a817008_Out_2.xyz), _Multiply_128d1fd95c401d8b899cab5f1390d224_Out_2);
            float _Float_a777f4e22dca81818a73c7929417c54f_Out_0 = 8;
            float3 _BakedGI_e1a2de84e6de3186be2da7d3db9d3453_Out_1;
            Unity_BakedGIScale_float(IN.WorldSpaceNormal, _BakedGI_e1a2de84e6de3186be2da7d3db9d3453_Out_1, IN.WorldSpacePosition, IN.uv1.xy, IN.uv2.xy);
            float3 _Multiply_d1c43dbcaf1eb48da57cb272dc2ed065_Out_2;
            Unity_Multiply_float((_Float_a777f4e22dca81818a73c7929417c54f_Out_0.xxx), _BakedGI_e1a2de84e6de3186be2da7d3db9d3453_Out_1, _Multiply_d1c43dbcaf1eb48da57cb272dc2ed065_Out_2);
            float3 _OneMinus_3955ed2b9057b685a37681dfd9b6f211_Out_1;
            Unity_OneMinus_float3(_Multiply_d1c43dbcaf1eb48da57cb272dc2ed065_Out_2, _OneMinus_3955ed2b9057b685a37681dfd9b6f211_Out_1);
            float3 _Step_d362b443237aed86a6b0e17fa99a64f5_Out_2;
            Unity_Step_float3(float3(1, 1, 1), _OneMinus_3955ed2b9057b685a37681dfd9b6f211_Out_1, _Step_d362b443237aed86a6b0e17fa99a64f5_Out_2);
            float3 _Add_88ea69e3d3f35e849b283907f55b9b17_Out_2;
            Unity_Add_float3(_Multiply_d1c43dbcaf1eb48da57cb272dc2ed065_Out_2, _Step_d362b443237aed86a6b0e17fa99a64f5_Out_2, _Add_88ea69e3d3f35e849b283907f55b9b17_Out_2);
            float3 _Multiply_cc3e6860fcb3de87b328e84b1eaeb395_Out_2;
            Unity_Multiply_float(_Multiply_128d1fd95c401d8b899cab5f1390d224_Out_2, _Add_88ea69e3d3f35e849b283907f55b9b17_Out_2, _Multiply_cc3e6860fcb3de87b328e84b1eaeb395_Out_2);
            #if defined(LIGHTMAP_ON)
            float3 _LIGHTMAP_0458efac5733c08fac8ebb6d98c10400_Out_0 = _Multiply_c83a20123005fe86956bbdd635820916_Out_2;
            #else
            float3 _LIGHTMAP_0458efac5733c08fac8ebb6d98c10400_Out_0 = _Multiply_cc3e6860fcb3de87b328e84b1eaeb395_Out_2;
            #endif
            float _Float_3faea16334e5ea86bcfca1b344a57be6_Out_0 = 0.5;
            float _Property_98501e3bb2eab28281b6849962299943_Out_0 = Vector1_A5B15C15;
            Bindings_MainLight_231093b74d3ab1341aa61c0ebb5d779d _MainLight_612e63efb8e4d08eb5027337e48edab0;
            _MainLight_612e63efb8e4d08eb5027337e48edab0.WorldSpaceNormal = IN.WorldSpaceNormal;
            _MainLight_612e63efb8e4d08eb5027337e48edab0.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            float3 _MainLight_612e63efb8e4d08eb5027337e48edab0_Direction_5;
            float3 _MainLight_612e63efb8e4d08eb5027337e48edab0_Color_1;
            float _MainLight_612e63efb8e4d08eb5027337e48edab0_ShadowAttenuation_2;
            float _MainLight_612e63efb8e4d08eb5027337e48edab0_SelfShadowing_3;
            SG_MainLight_231093b74d3ab1341aa61c0ebb5d779d(_MainLight_612e63efb8e4d08eb5027337e48edab0, _MainLight_612e63efb8e4d08eb5027337e48edab0_Direction_5, _MainLight_612e63efb8e4d08eb5027337e48edab0_Color_1, _MainLight_612e63efb8e4d08eb5027337e48edab0_ShadowAttenuation_2, _MainLight_612e63efb8e4d08eb5027337e48edab0_SelfShadowing_3);
            float3 _DirectSpecularCustomFunction_fcd2160ad70d8e8e8d394854e83d1cdc_Out_6;
            DirectSpecular_float(_Property_98501e3bb2eab28281b6849962299943_Out_0, _MainLight_612e63efb8e4d08eb5027337e48edab0_Direction_5, IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _DirectSpecularCustomFunction_fcd2160ad70d8e8e8d394854e83d1cdc_Out_6);
            float3 _Step_7e7270f34eb9ae88a28eb398c87a6389_Out_2;
            Unity_Step_float3((_Float_3faea16334e5ea86bcfca1b344a57be6_Out_0.xxx), _DirectSpecularCustomFunction_fcd2160ad70d8e8e8d394854e83d1cdc_Out_6, _Step_7e7270f34eb9ae88a28eb398c87a6389_Out_2);
            LightingModel_1 = _LIGHTMAP_0458efac5733c08fac8ebb6d98c10400_Out_0;
            DirectSpecular_2 = _Step_7e7270f34eb9ae88a28eb398c87a6389_Out_2;
        }

        void Unity_Clamp_float3(float3 In, float3 Min, float3 Max, out float3 Out)
        {
            Out = clamp(In, Min, Max);
        }

        struct Bindings_ToonShading_fbed86498f4059d42b9f1788c6dee1c2
        {
            float3 WorldSpaceNormal;
            float3 WorldSpaceViewDirection;
            float3 WorldSpacePosition;
            float3 AbsoluteWorldSpacePosition;
            half4 uv1;
            half4 uv2;
        };

        void SG_ToonShading_fbed86498f4059d42b9f1788c6dee1c2(float4 Color_601E5129, UnityTexture2D Texture2D_75C45C06, float3 Vector3_E2B204B9, Bindings_ToonShading_fbed86498f4059d42b9f1788c6dee1c2 IN, out float3 ShadingResult_1)
        {
            float _Float_957c6dcfd7ff405b940fb124530373ec_Out_0 = 1;
            Bindings_AdditionalLightsToon_87dc85b7edc8a8442adaa8215da4c975 _AdditionalLightsToon_522d6f0fce516085857775d629693765;
            _AdditionalLightsToon_522d6f0fce516085857775d629693765.WorldSpaceNormal = IN.WorldSpaceNormal;
            _AdditionalLightsToon_522d6f0fce516085857775d629693765.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
            _AdditionalLightsToon_522d6f0fce516085857775d629693765.WorldSpacePosition = IN.WorldSpacePosition;
            float4 _AdditionalLightsToon_522d6f0fce516085857775d629693765_Lighting_1;
            float _AdditionalLightsToon_522d6f0fce516085857775d629693765_Specular_2;
            SG_AdditionalLightsToon_87dc85b7edc8a8442adaa8215da4c975(_Float_957c6dcfd7ff405b940fb124530373ec_Out_0, _AdditionalLightsToon_522d6f0fce516085857775d629693765, _AdditionalLightsToon_522d6f0fce516085857775d629693765_Lighting_1, _AdditionalLightsToon_522d6f0fce516085857775d629693765_Specular_2);
            float _Float_dd45c170d5cc40768ba48fa24fb48c8f_Out_0 = 1;
            Bindings_ToonLightingModel_2146d4f705c217e489ca16fbb84d44d9 _ToonLightingModel_476222baf740f884bb3c8037fd266322;
            _ToonLightingModel_476222baf740f884bb3c8037fd266322.WorldSpaceNormal = IN.WorldSpaceNormal;
            _ToonLightingModel_476222baf740f884bb3c8037fd266322.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
            _ToonLightingModel_476222baf740f884bb3c8037fd266322.WorldSpacePosition = IN.WorldSpacePosition;
            _ToonLightingModel_476222baf740f884bb3c8037fd266322.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _ToonLightingModel_476222baf740f884bb3c8037fd266322.uv1 = IN.uv1;
            _ToonLightingModel_476222baf740f884bb3c8037fd266322.uv2 = IN.uv2;
            float3 _ToonLightingModel_476222baf740f884bb3c8037fd266322_LightingModel_1;
            float3 _ToonLightingModel_476222baf740f884bb3c8037fd266322_DirectSpecular_2;
            SG_ToonLightingModel_2146d4f705c217e489ca16fbb84d44d9(_Float_dd45c170d5cc40768ba48fa24fb48c8f_Out_0, NewGradient(1, 2, 2, float4(0, 0, 0, 0.01765469),float4(1, 1, 1, 1),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0), float2(1, 0),float2(1, 1),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0)), _ToonLightingModel_476222baf740f884bb3c8037fd266322, _ToonLightingModel_476222baf740f884bb3c8037fd266322_LightingModel_1, _ToonLightingModel_476222baf740f884bb3c8037fd266322_DirectSpecular_2);
            float3 _Add_63ee59e9ed8fcf82a40b6aff5d953a99_Out_2;
            Unity_Add_float3((_AdditionalLightsToon_522d6f0fce516085857775d629693765_Lighting_1.xyz), _ToonLightingModel_476222baf740f884bb3c8037fd266322_LightingModel_1, _Add_63ee59e9ed8fcf82a40b6aff5d953a99_Out_2);
            float3 _Property_51958772a319f88ca40c9bd6c3e4b814_Out_0 = Vector3_E2B204B9;
            float3 _Multiply_baab89e83466a88896036c96ab698f59_Out_2;
            Unity_Multiply_float(_Add_63ee59e9ed8fcf82a40b6aff5d953a99_Out_2, _Property_51958772a319f88ca40c9bd6c3e4b814_Out_0, _Multiply_baab89e83466a88896036c96ab698f59_Out_2);
            float4 _Property_ccfc64e126740e8289b25ec5613bda25_Out_0 = Color_601E5129;
            float _Split_51b72309f11b548283f9cb1a349bc6cf_R_1 = _Property_ccfc64e126740e8289b25ec5613bda25_Out_0[0];
            float _Split_51b72309f11b548283f9cb1a349bc6cf_G_2 = _Property_ccfc64e126740e8289b25ec5613bda25_Out_0[1];
            float _Split_51b72309f11b548283f9cb1a349bc6cf_B_3 = _Property_ccfc64e126740e8289b25ec5613bda25_Out_0[2];
            float _Split_51b72309f11b548283f9cb1a349bc6cf_A_4 = _Property_ccfc64e126740e8289b25ec5613bda25_Out_0[3];
            float3 _Vector3_7a9f39ede9f8948e88125976a1214728_Out_0 = float3(_Split_51b72309f11b548283f9cb1a349bc6cf_R_1, _Split_51b72309f11b548283f9cb1a349bc6cf_G_2, _Split_51b72309f11b548283f9cb1a349bc6cf_B_3);
            float3 _Multiply_9494ae00673c7282907e8c76bb19793a_Out_2;
            Unity_Multiply_float(_Vector3_7a9f39ede9f8948e88125976a1214728_Out_0, (_Split_51b72309f11b548283f9cb1a349bc6cf_A_4.xxx), _Multiply_9494ae00673c7282907e8c76bb19793a_Out_2);
            float3 _Add_90a11d4d8624d78a8cc2b8293f17fbe3_Out_2;
            Unity_Add_float3((_AdditionalLightsToon_522d6f0fce516085857775d629693765_Specular_2.xxx), _ToonLightingModel_476222baf740f884bb3c8037fd266322_DirectSpecular_2, _Add_90a11d4d8624d78a8cc2b8293f17fbe3_Out_2);
            float3 _Clamp_7de4925c649a8381a10a18afb8a48879_Out_3;
            Unity_Clamp_float3(_Add_90a11d4d8624d78a8cc2b8293f17fbe3_Out_2, float3(0, 0, 0), float3(1, 1, 1), _Clamp_7de4925c649a8381a10a18afb8a48879_Out_3);
            float3 _Multiply_86dfcce011f566839411f5596d36053f_Out_2;
            Unity_Multiply_float(_Multiply_9494ae00673c7282907e8c76bb19793a_Out_2, _Clamp_7de4925c649a8381a10a18afb8a48879_Out_3, _Multiply_86dfcce011f566839411f5596d36053f_Out_2);
            float3 _Add_13f444047663e480b82dc115de4795ca_Out_2;
            Unity_Add_float3(_Multiply_baab89e83466a88896036c96ab698f59_Out_2, _Multiply_86dfcce011f566839411f5596d36053f_Out_2, _Add_13f444047663e480b82dc115de4795ca_Out_2);
            ShadingResult_1 = _Add_13f444047663e480b82dc115de4795ca_Out_2;
        }

        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }

        void Unity_Subtract_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A - B;
        }

        void Unity_Length_float3(float3 In, out float Out)
        {
            Out = length(In);
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }

        void Unity_Floor_float(float In, out float Out)
        {
            Out = floor(In);
        }

        // 89be1983e036822f20a5ab757382b6d4
        #include "Assets/Shaders/CustomHLSL/Outline.hlsl"

        void Unity_Ceiling_float(float In, out float Out)
        {
            Out = ceil(In);
        }

        void Unity_Modulo_float(float A, float B, out float Out)
        {
            Out = fmod(A, B);
        }

        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }

        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }

        struct Bindings_Outline_36b1cdb3a2e056742ae9eed5db1cbfe9
        {
            float3 WorldSpacePosition;
            float4 ScreenPosition;
        };

        void SG_Outline_36b1cdb3a2e056742ae9eed5db1cbfe9(float Vector1_688861A9, float Vector1_E39B1B65, float Vector1_903A7FAB, Bindings_Outline_36b1cdb3a2e056742ae9eed5db1cbfe9 IN, out float Outlline_1)
        {
            float4 _ScreenPosition_2e560ddf91b3468b8f40c9b2c72d11c5_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
            float _Property_26b7060b4226f78a86a79767631afeef_Out_0 = Vector1_688861A9;
            float _Multiply_8ab15267716c0b81814f860a0bd0bd19_Out_2;
            Unity_Multiply_float(_Property_26b7060b4226f78a86a79767631afeef_Out_0, _ScreenParams.y, _Multiply_8ab15267716c0b81814f860a0bd0bd19_Out_2);
            float _Divide_58e8ef83aabb3c8e9a5938f52a3624ed_Out_2;
            Unity_Divide_float(_Multiply_8ab15267716c0b81814f860a0bd0bd19_Out_2, 1080, _Divide_58e8ef83aabb3c8e9a5938f52a3624ed_Out_2);
            float3 _Subtract_d634f3591866848e9c300d1b7f23c921_Out_2;
            Unity_Subtract_float3(IN.WorldSpacePosition, _WorldSpaceCameraPos, _Subtract_d634f3591866848e9c300d1b7f23c921_Out_2);
            float _Length_e0ffd3cf0df2d68b8a670ae08cc28a3f_Out_1;
            Unity_Length_float3(_Subtract_d634f3591866848e9c300d1b7f23c921_Out_2, _Length_e0ffd3cf0df2d68b8a670ae08cc28a3f_Out_1);
            float _Divide_76fd1406d293838a8413fcd681b20910_Out_2;
            Unity_Divide_float(_Length_e0ffd3cf0df2d68b8a670ae08cc28a3f_Out_1, 1000, _Divide_76fd1406d293838a8413fcd681b20910_Out_2);
            float _Subtract_2fe6a26a0c8a1280b0e4224ea52ca2d8_Out_2;
            Unity_Subtract_float(_Divide_58e8ef83aabb3c8e9a5938f52a3624ed_Out_2, _Divide_76fd1406d293838a8413fcd681b20910_Out_2, _Subtract_2fe6a26a0c8a1280b0e4224ea52ca2d8_Out_2);
            float _Clamp_ce27b759e9ff7a8191c59b19863f4ac0_Out_3;
            Unity_Clamp_float(_Subtract_2fe6a26a0c8a1280b0e4224ea52ca2d8_Out_2, 0, 50, _Clamp_ce27b759e9ff7a8191c59b19863f4ac0_Out_3);
            float _Floor_eb6a8290b997f582b5a5153d37f208d9_Out_1;
            Unity_Floor_float(_Clamp_ce27b759e9ff7a8191c59b19863f4ac0_Out_3, _Floor_eb6a8290b997f582b5a5153d37f208d9_Out_1);
            float _Property_fb2872ce9136f78a9750eed9f9011bcb_Out_0 = Vector1_E39B1B65;
            float _Property_0ad5d56ece29ec87a10b165888e2439d_Out_0 = Vector1_903A7FAB;
            float _OutlineObjectCustomFunction_ceba13a364372e858a1bd1283e57e3c8_Out_4;
            OutlineObject_float((_ScreenPosition_2e560ddf91b3468b8f40c9b2c72d11c5_Out_0.xy), _Floor_eb6a8290b997f582b5a5153d37f208d9_Out_1, _Property_fb2872ce9136f78a9750eed9f9011bcb_Out_0, _Property_0ad5d56ece29ec87a10b165888e2439d_Out_0, _OutlineObjectCustomFunction_ceba13a364372e858a1bd1283e57e3c8_Out_4);
            float4 _ScreenPosition_50303d2a4e3cf185981701786c945521_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
            float _Ceiling_f7dc6733b588538ab2f5fd7563ac8c7d_Out_1;
            Unity_Ceiling_float(_Clamp_ce27b759e9ff7a8191c59b19863f4ac0_Out_3, _Ceiling_f7dc6733b588538ab2f5fd7563ac8c7d_Out_1);
            float _Property_db9d2355347f3c808f2ba2909ffd1167_Out_0 = Vector1_E39B1B65;
            float _Property_dc32a5e5d4696f8b8fb2ca945f29535c_Out_0 = Vector1_903A7FAB;
            float _OutlineObjectCustomFunction_03f1257844d67c88b0c87c59c190780d_Out_4;
            OutlineObject_float((_ScreenPosition_50303d2a4e3cf185981701786c945521_Out_0.xy), _Ceiling_f7dc6733b588538ab2f5fd7563ac8c7d_Out_1, _Property_db9d2355347f3c808f2ba2909ffd1167_Out_0, _Property_dc32a5e5d4696f8b8fb2ca945f29535c_Out_0, _OutlineObjectCustomFunction_03f1257844d67c88b0c87c59c190780d_Out_4);
            float _Modulo_6413c6dd820a908299f9d6d1e31e6b6d_Out_2;
            Unity_Modulo_float(_Clamp_ce27b759e9ff7a8191c59b19863f4ac0_Out_3, 1, _Modulo_6413c6dd820a908299f9d6d1e31e6b6d_Out_2);
            float _Lerp_67c8f4bfd2e0e085b2a615ef2a29899f_Out_3;
            Unity_Lerp_float(_OutlineObjectCustomFunction_ceba13a364372e858a1bd1283e57e3c8_Out_4, _OutlineObjectCustomFunction_03f1257844d67c88b0c87c59c190780d_Out_4, _Modulo_6413c6dd820a908299f9d6d1e31e6b6d_Out_2, _Lerp_67c8f4bfd2e0e085b2a615ef2a29899f_Out_3);
            float _OneMinus_8716b951fb801c838f0b39eca5425cfe_Out_1;
            Unity_OneMinus_float(_Lerp_67c8f4bfd2e0e085b2a615ef2a29899f_Out_3, _OneMinus_8716b951fb801c838f0b39eca5425cfe_Out_1);
            Outlline_1 = _OneMinus_8716b951fb801c838f0b39eca5425cfe_Out_1;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 _Property_a60ed4f8ff52fc829b1ab2f22f5df14b_Out_0 = _SpecularColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            UnityTexture2D _Property_b1224cdeaf4cdb82aec016db3e3c06ec_Out_0 = UnityBuildTexture2DStructNoScale(_SpecularMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 _Property_0c463843746e288391b8f14568c1b226_Out_0 = _MainColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            UnityTexture2D _Property_e2d0c96d6ea00780805055033bae5838_Out_0 = UnityBuildTexture2DStructNoScale(_MainTexture);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float2 _Property_b1ef9ff04e418d8ca08a9d853ebb74fb_Out_0 = _Tiling;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float2 _Property_476ca1516c65628ba31419a95cbea98c_Out_0 = _Offset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            Bindings_Albedo_e5a8c819ad3623244a943a45dac4ffa4 _Albedo_cf2dc1721f2db789a4f0673fe3b88499;
            _Albedo_cf2dc1721f2db789a4f0673fe3b88499.uv0 = IN.uv0;
            float4 _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1;
            SG_Albedo_e5a8c819ad3623244a943a45dac4ffa4(_Property_0c463843746e288391b8f14568c1b226_Out_0, _Property_e2d0c96d6ea00780805055033bae5838_Out_0, _Property_b1ef9ff04e418d8ca08a9d853ebb74fb_Out_0, _Property_476ca1516c65628ba31419a95cbea98c_Out_0, _Albedo_cf2dc1721f2db789a4f0673fe3b88499, _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            Bindings_ToonShading_fbed86498f4059d42b9f1788c6dee1c2 _ToonShading_bb6f3ca58f75fe85a94ffe9040f484e4;
            _ToonShading_bb6f3ca58f75fe85a94ffe9040f484e4.WorldSpaceNormal = IN.WorldSpaceNormal;
            _ToonShading_bb6f3ca58f75fe85a94ffe9040f484e4.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
            _ToonShading_bb6f3ca58f75fe85a94ffe9040f484e4.WorldSpacePosition = IN.WorldSpacePosition;
            _ToonShading_bb6f3ca58f75fe85a94ffe9040f484e4.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _ToonShading_bb6f3ca58f75fe85a94ffe9040f484e4.uv1 = IN.uv1;
            _ToonShading_bb6f3ca58f75fe85a94ffe9040f484e4.uv2 = IN.uv2;
            float3 _ToonShading_bb6f3ca58f75fe85a94ffe9040f484e4_ShadingResult_1;
            SG_ToonShading_fbed86498f4059d42b9f1788c6dee1c2(_Property_a60ed4f8ff52fc829b1ab2f22f5df14b_Out_0, _Property_b1224cdeaf4cdb82aec016db3e3c06ec_Out_0, (_Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1.xyz), _ToonShading_bb6f3ca58f75fe85a94ffe9040f484e4, _ToonShading_bb6f3ca58f75fe85a94ffe9040f484e4_ShadingResult_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float _Property_6703ef29918b648193c61392b2b9e0f6_Out_0 = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float _Property_7dcffaf848e6eb80bac7964c2b25e439_Out_0 = _OutlineDepthSensitivity;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float _Property_cf5c51345dbc1988b2c3407a0cf5af74_Out_0 = _OutlineNormalsSensitivity;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            Bindings_Outline_36b1cdb3a2e056742ae9eed5db1cbfe9 _Outline_fb356922aae02284b26b678290594e65;
            _Outline_fb356922aae02284b26b678290594e65.WorldSpacePosition = IN.WorldSpacePosition;
            _Outline_fb356922aae02284b26b678290594e65.ScreenPosition = IN.ScreenPosition;
            float _Outline_fb356922aae02284b26b678290594e65_Outlline_1;
            SG_Outline_36b1cdb3a2e056742ae9eed5db1cbfe9(_Property_6703ef29918b648193c61392b2b9e0f6_Out_0, _Property_7dcffaf848e6eb80bac7964c2b25e439_Out_0, _Property_cf5c51345dbc1988b2c3407a0cf5af74_Out_0, _Outline_fb356922aae02284b26b678290594e65, _Outline_fb356922aae02284b26b678290594e65_Outlline_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 _Multiply_b922bfeebbb4f984b7008c5cf9a6a9ae_Out_2;
            Unity_Multiply_float(_ToonShading_bb6f3ca58f75fe85a94ffe9040f484e4_ShadingResult_1, (_Outline_fb356922aae02284b26b678290594e65_Outlline_1.xxx), _Multiply_b922bfeebbb4f984b7008c5cf9a6a9ae_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float _Split_7b58296a546e388389f1dca27ac980fb_R_1 = _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1[0];
            float _Split_7b58296a546e388389f1dca27ac980fb_G_2 = _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1[1];
            float _Split_7b58296a546e388389f1dca27ac980fb_B_3 = _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1[2];
            float _Split_7b58296a546e388389f1dca27ac980fb_A_4 = _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1[3];
            #endif
            surface.BaseColor = _Multiply_b922bfeebbb4f984b7008c5cf9a6a9ae_Out_2;
            surface.Alpha = _Split_7b58296a546e388389f1dca27ac980fb_A_4;
            surface.AlphaClipThreshold = 0.5;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.ObjectSpaceNormal =           input.normalOS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.ObjectSpaceTangent =          input.tangentOS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.ObjectSpacePosition =         input.positionOS;
        #endif


            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        float3 unnormalizedNormalWS = input.normalWS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        #endif



        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.WorldSpaceNormal =            renormFactor*input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        #endif



        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.WorldSpaceViewDirection =     input.viewDirectionWS; //TODO: by default normalized in HD, but not in universal
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.WorldSpacePosition =          input.positionWS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionWS);
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.uv0 =                         input.texCoord0;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.uv1 =                         input.texCoord1;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.uv2 =                         input.texCoord2;
        #endif

        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        ColorMask 0

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            #pragma multi_compile _ _CASTING_PUNCTUAL_LIGHT_SHADOW
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
        #pragma multi_compile _ _SHADOWS_SOFT
        #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile _ LIGHTMAP_ON

        #if defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_1
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_2
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT)
            #define KEYWORD_PERMUTATION_3
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_4
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_5
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_6
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE)
            #define KEYWORD_PERMUTATION_7
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_8
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_9
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_SHADOWS_SOFT) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_10
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_SHADOWS_SOFT)
            #define KEYWORD_PERMUTATION_11
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_12
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_13
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_14
        #elif defined(_MAIN_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_15
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_16
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_17
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_18
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT)
            #define KEYWORD_PERMUTATION_19
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_20
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_21
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_22
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE)
            #define KEYWORD_PERMUTATION_23
        #elif defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_24
        #elif defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_25
        #elif defined(_SHADOWS_SOFT) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_26
        #elif defined(_SHADOWS_SOFT)
            #define KEYWORD_PERMUTATION_27
        #elif defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_28
        #elif defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_29
        #elif defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_30
        #else
            #define KEYWORD_PERMUTATION_31
        #endif


            // Defines
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define _AlphaClip 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define ATTRIBUTES_NEED_NORMAL
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define ATTRIBUTES_NEED_TANGENT
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define VARYINGS_NEED_TEXCOORD0
        #endif

            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_SHADOWCASTER
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 uv0 : TEXCOORD0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 texCoord0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 uv0;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 interp0 : TEXCOORD0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };

            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _MainColor;
        float4 _MainTexture_TexelSize;
        float _Smoothness;
        float4 _SpecularColor;
        float4 _SpecularMap_TexelSize;
        float _OutlineThickness;
        float _OutlineDepthSensitivity;
        float _OutlineNormalsSensitivity;
        float2 _Tiling;
        float2 _Offset;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTexture);
        SAMPLER(sampler_MainTexture);
        TEXTURE2D(_SpecularMap);
        SAMPLER(sampler_SpecularMap);

            // Graph Functions
            
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        struct Bindings_Albedo_e5a8c819ad3623244a943a45dac4ffa4
        {
            half4 uv0;
        };

        void SG_Albedo_e5a8c819ad3623244a943a45dac4ffa4(float4 Vector4_12A72EFC, UnityTexture2D Texture2D_9644D008, float2 Vector2_E2350C2, float2 Vector2_D0710BCD, Bindings_Albedo_e5a8c819ad3623244a943a45dac4ffa4 IN, out float4 AlbedoTransp_1)
        {
            float4 _Property_ead5a42fe40ddf8890ef8f59627dbf00_Out_0 = Vector4_12A72EFC;
            float _Split_eefb1b94fc79aa81969b28152339aaa5_R_1 = _Property_ead5a42fe40ddf8890ef8f59627dbf00_Out_0[0];
            float _Split_eefb1b94fc79aa81969b28152339aaa5_G_2 = _Property_ead5a42fe40ddf8890ef8f59627dbf00_Out_0[1];
            float _Split_eefb1b94fc79aa81969b28152339aaa5_B_3 = _Property_ead5a42fe40ddf8890ef8f59627dbf00_Out_0[2];
            float _Split_eefb1b94fc79aa81969b28152339aaa5_A_4 = _Property_ead5a42fe40ddf8890ef8f59627dbf00_Out_0[3];
            float4 _Combine_0989ac05ac713585b1970bd9dce2d35a_RGBA_4;
            float3 _Combine_0989ac05ac713585b1970bd9dce2d35a_RGB_5;
            float2 _Combine_0989ac05ac713585b1970bd9dce2d35a_RG_6;
            Unity_Combine_float(_Split_eefb1b94fc79aa81969b28152339aaa5_R_1, _Split_eefb1b94fc79aa81969b28152339aaa5_G_2, _Split_eefb1b94fc79aa81969b28152339aaa5_B_3, 1, _Combine_0989ac05ac713585b1970bd9dce2d35a_RGBA_4, _Combine_0989ac05ac713585b1970bd9dce2d35a_RGB_5, _Combine_0989ac05ac713585b1970bd9dce2d35a_RG_6);
            UnityTexture2D _Property_c6a26ce271d98f84bb13cd7ce0ae398d_Out_0 = Texture2D_9644D008;
            float2 _Property_fe6e35ca6b347f83a931216e0b119ec0_Out_0 = Vector2_E2350C2;
            float2 _Property_422e593a494f798fbe504a4f2b01c59a_Out_0 = Vector2_D0710BCD;
            float2 _TilingAndOffset_7708bc2bff71f48e91e0337bac4a6137_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_fe6e35ca6b347f83a931216e0b119ec0_Out_0, _Property_422e593a494f798fbe504a4f2b01c59a_Out_0, _TilingAndOffset_7708bc2bff71f48e91e0337bac4a6137_Out_3);
            float4 _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c6a26ce271d98f84bb13cd7ce0ae398d_Out_0.tex, _Property_c6a26ce271d98f84bb13cd7ce0ae398d_Out_0.samplerstate, _TilingAndOffset_7708bc2bff71f48e91e0337bac4a6137_Out_3);
            float _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_R_4 = _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0.r;
            float _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_G_5 = _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0.g;
            float _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_B_6 = _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0.b;
            float _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_A_7 = _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0.a;
            float4 _Multiply_2bed8dfc9ac182839f4890b363090fbe_Out_2;
            Unity_Multiply_float(_Combine_0989ac05ac713585b1970bd9dce2d35a_RGBA_4, _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0, _Multiply_2bed8dfc9ac182839f4890b363090fbe_Out_2);
            AlbedoTransp_1 = _Multiply_2bed8dfc9ac182839f4890b363090fbe_Out_2;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 _Property_0c463843746e288391b8f14568c1b226_Out_0 = _MainColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            UnityTexture2D _Property_e2d0c96d6ea00780805055033bae5838_Out_0 = UnityBuildTexture2DStructNoScale(_MainTexture);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float2 _Property_b1ef9ff04e418d8ca08a9d853ebb74fb_Out_0 = _Tiling;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float2 _Property_476ca1516c65628ba31419a95cbea98c_Out_0 = _Offset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            Bindings_Albedo_e5a8c819ad3623244a943a45dac4ffa4 _Albedo_cf2dc1721f2db789a4f0673fe3b88499;
            _Albedo_cf2dc1721f2db789a4f0673fe3b88499.uv0 = IN.uv0;
            float4 _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1;
            SG_Albedo_e5a8c819ad3623244a943a45dac4ffa4(_Property_0c463843746e288391b8f14568c1b226_Out_0, _Property_e2d0c96d6ea00780805055033bae5838_Out_0, _Property_b1ef9ff04e418d8ca08a9d853ebb74fb_Out_0, _Property_476ca1516c65628ba31419a95cbea98c_Out_0, _Albedo_cf2dc1721f2db789a4f0673fe3b88499, _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float _Split_7b58296a546e388389f1dca27ac980fb_R_1 = _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1[0];
            float _Split_7b58296a546e388389f1dca27ac980fb_G_2 = _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1[1];
            float _Split_7b58296a546e388389f1dca27ac980fb_B_3 = _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1[2];
            float _Split_7b58296a546e388389f1dca27ac980fb_A_4 = _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1[3];
            #endif
            surface.Alpha = _Split_7b58296a546e388389f1dca27ac980fb_A_4;
            surface.AlphaClipThreshold = 0.5;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.ObjectSpaceNormal =           input.normalOS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.ObjectSpaceTangent =          input.tangentOS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.ObjectSpacePosition =         input.positionOS;
        #endif


            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.uv0 =                         input.texCoord0;
        #endif

        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "DepthOnly"
            Tags
            {
                "LightMode" = "DepthOnly"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        ColorMask 0

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
        #pragma multi_compile _ _SHADOWS_SOFT
        #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile _ LIGHTMAP_ON

        #if defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_1
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_2
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT)
            #define KEYWORD_PERMUTATION_3
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_4
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_5
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_6
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE)
            #define KEYWORD_PERMUTATION_7
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_8
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_9
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_SHADOWS_SOFT) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_10
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_SHADOWS_SOFT)
            #define KEYWORD_PERMUTATION_11
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_12
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_13
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_14
        #elif defined(_MAIN_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_15
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_16
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_17
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_18
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT)
            #define KEYWORD_PERMUTATION_19
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_20
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_21
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_22
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE)
            #define KEYWORD_PERMUTATION_23
        #elif defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_24
        #elif defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_25
        #elif defined(_SHADOWS_SOFT) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_26
        #elif defined(_SHADOWS_SOFT)
            #define KEYWORD_PERMUTATION_27
        #elif defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_28
        #elif defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_29
        #elif defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_30
        #else
            #define KEYWORD_PERMUTATION_31
        #endif


            // Defines
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define _AlphaClip 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define ATTRIBUTES_NEED_NORMAL
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define ATTRIBUTES_NEED_TANGENT
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define VARYINGS_NEED_TEXCOORD0
        #endif

            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHONLY
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 uv0 : TEXCOORD0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 texCoord0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 uv0;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 interp0 : TEXCOORD0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };

            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _MainColor;
        float4 _MainTexture_TexelSize;
        float _Smoothness;
        float4 _SpecularColor;
        float4 _SpecularMap_TexelSize;
        float _OutlineThickness;
        float _OutlineDepthSensitivity;
        float _OutlineNormalsSensitivity;
        float2 _Tiling;
        float2 _Offset;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTexture);
        SAMPLER(sampler_MainTexture);
        TEXTURE2D(_SpecularMap);
        SAMPLER(sampler_SpecularMap);

            // Graph Functions
            
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        struct Bindings_Albedo_e5a8c819ad3623244a943a45dac4ffa4
        {
            half4 uv0;
        };

        void SG_Albedo_e5a8c819ad3623244a943a45dac4ffa4(float4 Vector4_12A72EFC, UnityTexture2D Texture2D_9644D008, float2 Vector2_E2350C2, float2 Vector2_D0710BCD, Bindings_Albedo_e5a8c819ad3623244a943a45dac4ffa4 IN, out float4 AlbedoTransp_1)
        {
            float4 _Property_ead5a42fe40ddf8890ef8f59627dbf00_Out_0 = Vector4_12A72EFC;
            float _Split_eefb1b94fc79aa81969b28152339aaa5_R_1 = _Property_ead5a42fe40ddf8890ef8f59627dbf00_Out_0[0];
            float _Split_eefb1b94fc79aa81969b28152339aaa5_G_2 = _Property_ead5a42fe40ddf8890ef8f59627dbf00_Out_0[1];
            float _Split_eefb1b94fc79aa81969b28152339aaa5_B_3 = _Property_ead5a42fe40ddf8890ef8f59627dbf00_Out_0[2];
            float _Split_eefb1b94fc79aa81969b28152339aaa5_A_4 = _Property_ead5a42fe40ddf8890ef8f59627dbf00_Out_0[3];
            float4 _Combine_0989ac05ac713585b1970bd9dce2d35a_RGBA_4;
            float3 _Combine_0989ac05ac713585b1970bd9dce2d35a_RGB_5;
            float2 _Combine_0989ac05ac713585b1970bd9dce2d35a_RG_6;
            Unity_Combine_float(_Split_eefb1b94fc79aa81969b28152339aaa5_R_1, _Split_eefb1b94fc79aa81969b28152339aaa5_G_2, _Split_eefb1b94fc79aa81969b28152339aaa5_B_3, 1, _Combine_0989ac05ac713585b1970bd9dce2d35a_RGBA_4, _Combine_0989ac05ac713585b1970bd9dce2d35a_RGB_5, _Combine_0989ac05ac713585b1970bd9dce2d35a_RG_6);
            UnityTexture2D _Property_c6a26ce271d98f84bb13cd7ce0ae398d_Out_0 = Texture2D_9644D008;
            float2 _Property_fe6e35ca6b347f83a931216e0b119ec0_Out_0 = Vector2_E2350C2;
            float2 _Property_422e593a494f798fbe504a4f2b01c59a_Out_0 = Vector2_D0710BCD;
            float2 _TilingAndOffset_7708bc2bff71f48e91e0337bac4a6137_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_fe6e35ca6b347f83a931216e0b119ec0_Out_0, _Property_422e593a494f798fbe504a4f2b01c59a_Out_0, _TilingAndOffset_7708bc2bff71f48e91e0337bac4a6137_Out_3);
            float4 _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c6a26ce271d98f84bb13cd7ce0ae398d_Out_0.tex, _Property_c6a26ce271d98f84bb13cd7ce0ae398d_Out_0.samplerstate, _TilingAndOffset_7708bc2bff71f48e91e0337bac4a6137_Out_3);
            float _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_R_4 = _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0.r;
            float _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_G_5 = _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0.g;
            float _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_B_6 = _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0.b;
            float _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_A_7 = _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0.a;
            float4 _Multiply_2bed8dfc9ac182839f4890b363090fbe_Out_2;
            Unity_Multiply_float(_Combine_0989ac05ac713585b1970bd9dce2d35a_RGBA_4, _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0, _Multiply_2bed8dfc9ac182839f4890b363090fbe_Out_2);
            AlbedoTransp_1 = _Multiply_2bed8dfc9ac182839f4890b363090fbe_Out_2;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 _Property_0c463843746e288391b8f14568c1b226_Out_0 = _MainColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            UnityTexture2D _Property_e2d0c96d6ea00780805055033bae5838_Out_0 = UnityBuildTexture2DStructNoScale(_MainTexture);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float2 _Property_b1ef9ff04e418d8ca08a9d853ebb74fb_Out_0 = _Tiling;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float2 _Property_476ca1516c65628ba31419a95cbea98c_Out_0 = _Offset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            Bindings_Albedo_e5a8c819ad3623244a943a45dac4ffa4 _Albedo_cf2dc1721f2db789a4f0673fe3b88499;
            _Albedo_cf2dc1721f2db789a4f0673fe3b88499.uv0 = IN.uv0;
            float4 _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1;
            SG_Albedo_e5a8c819ad3623244a943a45dac4ffa4(_Property_0c463843746e288391b8f14568c1b226_Out_0, _Property_e2d0c96d6ea00780805055033bae5838_Out_0, _Property_b1ef9ff04e418d8ca08a9d853ebb74fb_Out_0, _Property_476ca1516c65628ba31419a95cbea98c_Out_0, _Albedo_cf2dc1721f2db789a4f0673fe3b88499, _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float _Split_7b58296a546e388389f1dca27ac980fb_R_1 = _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1[0];
            float _Split_7b58296a546e388389f1dca27ac980fb_G_2 = _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1[1];
            float _Split_7b58296a546e388389f1dca27ac980fb_B_3 = _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1[2];
            float _Split_7b58296a546e388389f1dca27ac980fb_A_4 = _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1[3];
            #endif
            surface.Alpha = _Split_7b58296a546e388389f1dca27ac980fb_A_4;
            surface.AlphaClipThreshold = 0.5;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.ObjectSpaceNormal =           input.normalOS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.ObjectSpaceTangent =          input.tangentOS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.ObjectSpacePosition =         input.positionOS;
        #endif


            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.uv0 =                         input.texCoord0;
        #endif

        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

            ENDHLSL
        }
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Opaque"
            "UniversalMaterialType" = "Unlit"
            "Queue"="AlphaTest"
        }
        Pass
        {
            Name "Pass"
            Tags
            {
                // LightMode: <None>
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma shader_feature _ _SAMPLE_GI
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
        #pragma multi_compile _ _SHADOWS_SOFT
        #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile _ LIGHTMAP_ON

        #if defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_1
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_2
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT)
            #define KEYWORD_PERMUTATION_3
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_4
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_5
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_6
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE)
            #define KEYWORD_PERMUTATION_7
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_8
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_9
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_SHADOWS_SOFT) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_10
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_SHADOWS_SOFT)
            #define KEYWORD_PERMUTATION_11
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_12
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_13
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_14
        #elif defined(_MAIN_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_15
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_16
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_17
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_18
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT)
            #define KEYWORD_PERMUTATION_19
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_20
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_21
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_22
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE)
            #define KEYWORD_PERMUTATION_23
        #elif defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_24
        #elif defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_25
        #elif defined(_SHADOWS_SOFT) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_26
        #elif defined(_SHADOWS_SOFT)
            #define KEYWORD_PERMUTATION_27
        #elif defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_28
        #elif defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_29
        #elif defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_30
        #else
            #define KEYWORD_PERMUTATION_31
        #endif


            // Defines
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define _AlphaClip 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define ATTRIBUTES_NEED_NORMAL
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define ATTRIBUTES_NEED_TANGENT
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define ATTRIBUTES_NEED_TEXCOORD2
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define VARYINGS_NEED_POSITION_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define VARYINGS_NEED_NORMAL_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define VARYINGS_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define VARYINGS_NEED_TEXCOORD1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define VARYINGS_NEED_TEXCOORD2
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #endif

            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_UNLIT
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 uv1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 uv2 : TEXCOORD2;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 texCoord0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 texCoord1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 texCoord2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 viewDirectionWS;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 WorldSpaceViewDirection;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 WorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 AbsoluteWorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 ScreenPosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 uv1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 uv2;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 interp0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 interp1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 interp2 : TEXCOORD2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 interp3 : TEXCOORD3;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 interp4 : TEXCOORD4;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 interp5 : TEXCOORD5;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };

            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.texCoord0;
            output.interp3.xyzw =  input.texCoord1;
            output.interp4.xyzw =  input.texCoord2;
            output.interp5.xyz =  input.viewDirectionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.texCoord0 = input.interp2.xyzw;
            output.texCoord1 = input.interp3.xyzw;
            output.texCoord2 = input.interp4.xyzw;
            output.viewDirectionWS = input.interp5.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _MainColor;
        float4 _MainTexture_TexelSize;
        float _Smoothness;
        float4 _SpecularColor;
        float4 _SpecularMap_TexelSize;
        float _OutlineThickness;
        float _OutlineDepthSensitivity;
        float _OutlineNormalsSensitivity;
        float2 _Tiling;
        float2 _Offset;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTexture);
        SAMPLER(sampler_MainTexture);
        TEXTURE2D(_SpecularMap);
        SAMPLER(sampler_SpecularMap);

            // Graph Functions
            
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        struct Bindings_Albedo_e5a8c819ad3623244a943a45dac4ffa4
        {
            half4 uv0;
        };

        void SG_Albedo_e5a8c819ad3623244a943a45dac4ffa4(float4 Vector4_12A72EFC, UnityTexture2D Texture2D_9644D008, float2 Vector2_E2350C2, float2 Vector2_D0710BCD, Bindings_Albedo_e5a8c819ad3623244a943a45dac4ffa4 IN, out float4 AlbedoTransp_1)
        {
            float4 _Property_ead5a42fe40ddf8890ef8f59627dbf00_Out_0 = Vector4_12A72EFC;
            float _Split_eefb1b94fc79aa81969b28152339aaa5_R_1 = _Property_ead5a42fe40ddf8890ef8f59627dbf00_Out_0[0];
            float _Split_eefb1b94fc79aa81969b28152339aaa5_G_2 = _Property_ead5a42fe40ddf8890ef8f59627dbf00_Out_0[1];
            float _Split_eefb1b94fc79aa81969b28152339aaa5_B_3 = _Property_ead5a42fe40ddf8890ef8f59627dbf00_Out_0[2];
            float _Split_eefb1b94fc79aa81969b28152339aaa5_A_4 = _Property_ead5a42fe40ddf8890ef8f59627dbf00_Out_0[3];
            float4 _Combine_0989ac05ac713585b1970bd9dce2d35a_RGBA_4;
            float3 _Combine_0989ac05ac713585b1970bd9dce2d35a_RGB_5;
            float2 _Combine_0989ac05ac713585b1970bd9dce2d35a_RG_6;
            Unity_Combine_float(_Split_eefb1b94fc79aa81969b28152339aaa5_R_1, _Split_eefb1b94fc79aa81969b28152339aaa5_G_2, _Split_eefb1b94fc79aa81969b28152339aaa5_B_3, 1, _Combine_0989ac05ac713585b1970bd9dce2d35a_RGBA_4, _Combine_0989ac05ac713585b1970bd9dce2d35a_RGB_5, _Combine_0989ac05ac713585b1970bd9dce2d35a_RG_6);
            UnityTexture2D _Property_c6a26ce271d98f84bb13cd7ce0ae398d_Out_0 = Texture2D_9644D008;
            float2 _Property_fe6e35ca6b347f83a931216e0b119ec0_Out_0 = Vector2_E2350C2;
            float2 _Property_422e593a494f798fbe504a4f2b01c59a_Out_0 = Vector2_D0710BCD;
            float2 _TilingAndOffset_7708bc2bff71f48e91e0337bac4a6137_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_fe6e35ca6b347f83a931216e0b119ec0_Out_0, _Property_422e593a494f798fbe504a4f2b01c59a_Out_0, _TilingAndOffset_7708bc2bff71f48e91e0337bac4a6137_Out_3);
            float4 _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c6a26ce271d98f84bb13cd7ce0ae398d_Out_0.tex, _Property_c6a26ce271d98f84bb13cd7ce0ae398d_Out_0.samplerstate, _TilingAndOffset_7708bc2bff71f48e91e0337bac4a6137_Out_3);
            float _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_R_4 = _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0.r;
            float _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_G_5 = _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0.g;
            float _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_B_6 = _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0.b;
            float _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_A_7 = _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0.a;
            float4 _Multiply_2bed8dfc9ac182839f4890b363090fbe_Out_2;
            Unity_Multiply_float(_Combine_0989ac05ac713585b1970bd9dce2d35a_RGBA_4, _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0, _Multiply_2bed8dfc9ac182839f4890b363090fbe_Out_2);
            AlbedoTransp_1 = _Multiply_2bed8dfc9ac182839f4890b363090fbe_Out_2;
        }

        // c3db79911ce3b41a0f2b2d6cf4a329f9
        #include "Assets/Shaders/CustomHLSL/CustomLighting.hlsl"

        struct Bindings_AdditionalLights_1b03813eb6f91994b841c8e22a1e1806
        {
            float3 WorldSpaceNormal;
            float3 WorldSpaceViewDirection;
            float3 WorldSpacePosition;
        };

        void SG_AdditionalLights_1b03813eb6f91994b841c8e22a1e1806(float Vector1_E56B297F, Bindings_AdditionalLights_1b03813eb6f91994b841c8e22a1e1806 IN, out float3 LightDiffuse_1, out float3 Specular_2)
        {
            float _Property_0c14249b5acf138c9865bbe708691426_Out_0 = Vector1_E56B297F;
            float3 _AdditionalLightsCustomFunction_6fd8cab1f3391f89b26a5e7454672aa1_Diffuse_1;
            float3 _AdditionalLightsCustomFunction_6fd8cab1f3391f89b26a5e7454672aa1_Specular_2;
            AdditionalLights_float(_Property_0c14249b5acf138c9865bbe708691426_Out_0, IN.WorldSpacePosition, IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _AdditionalLightsCustomFunction_6fd8cab1f3391f89b26a5e7454672aa1_Diffuse_1, _AdditionalLightsCustomFunction_6fd8cab1f3391f89b26a5e7454672aa1_Specular_2);
            LightDiffuse_1 = _AdditionalLightsCustomFunction_6fd8cab1f3391f89b26a5e7454672aa1_Diffuse_1;
            Specular_2 = _AdditionalLightsCustomFunction_6fd8cab1f3391f89b26a5e7454672aa1_Specular_2;
        }

        void Unity_ColorspaceConversion_RGB_HSV_float(float3 In, out float3 Out)
        {
            float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
            float4 P = lerp(float4(In.bg, K.wz), float4(In.gb, K.xy), step(In.b, In.g));
            float4 Q = lerp(float4(P.xyw, In.r), float4(In.r, P.yzx), step(P.x, In.r));
            float D = Q.x - min(Q.w, Q.y);
            float  E = 1e-10;
            Out = float3(abs(Q.z + (Q.w - Q.y)/(6.0 * D + E)), D / (Q.x + E), Q.x);
        }

        void Unity_SampleGradientV0_float(Gradient Gradient, float Time, out float4 Out)
        {
            float3 color = Gradient.colors[0].rgb;
            [unroll]
            for (int c = 1; c < 8; c++)
            {
                float colorPos = saturate((Time - Gradient.colors[c - 1].w) / (Gradient.colors[c].w - Gradient.colors[c - 1].w)) * step(c, Gradient.colorsLength - 1);
                color = lerp(color, Gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), Gradient.type));
            }
        #ifndef UNITY_COLORSPACE_GAMMA
            color = SRGBToLinear(color);
        #endif
            float alpha = Gradient.alphas[0].x;
            [unroll]
            for (int a = 1; a < 8; a++)
            {
                float alphaPos = saturate((Time - Gradient.alphas[a - 1].y) / (Gradient.alphas[a].y - Gradient.alphas[a - 1].y)) * step(a, Gradient.alphasLength - 1);
                alpha = lerp(alpha, Gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), Gradient.type));
            }
            Out = float4(color, alpha);
        }

        void Unity_ColorspaceConversion_HSV_RGB_float(float3 In, out float3 Out)
        {
            float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
            float3 P = abs(frac(In.xxx + K.xyz) * 6.0 - K.www);
            Out = In.z * lerp(K.xxx, saturate(P - K.xxx), In.y);
        }

        void Unity_Step_float3(float3 Edge, float3 In, out float3 Out)
        {
            Out = step(Edge, In);
        }

        struct Bindings_AdditionalLightsToon_87dc85b7edc8a8442adaa8215da4c975
        {
            float3 WorldSpaceNormal;
            float3 WorldSpaceViewDirection;
            float3 WorldSpacePosition;
        };

        void SG_AdditionalLightsToon_87dc85b7edc8a8442adaa8215da4c975(float Vector1_5CCA1F29, Bindings_AdditionalLightsToon_87dc85b7edc8a8442adaa8215da4c975 IN, out float4 Lighting_1, out float Specular_2)
        {
            float _Property_a0bf9a7225753688bc2d1fd921f6d2cc_Out_0 = Vector1_5CCA1F29;
            Bindings_AdditionalLights_1b03813eb6f91994b841c8e22a1e1806 _AdditionalLights_53ace4769a03878cab4dfc8713da150a;
            _AdditionalLights_53ace4769a03878cab4dfc8713da150a.WorldSpaceNormal = IN.WorldSpaceNormal;
            _AdditionalLights_53ace4769a03878cab4dfc8713da150a.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
            _AdditionalLights_53ace4769a03878cab4dfc8713da150a.WorldSpacePosition = IN.WorldSpacePosition;
            float3 _AdditionalLights_53ace4769a03878cab4dfc8713da150a_LightDiffuse_1;
            float3 _AdditionalLights_53ace4769a03878cab4dfc8713da150a_Specular_2;
            SG_AdditionalLights_1b03813eb6f91994b841c8e22a1e1806(_Property_a0bf9a7225753688bc2d1fd921f6d2cc_Out_0, _AdditionalLights_53ace4769a03878cab4dfc8713da150a, _AdditionalLights_53ace4769a03878cab4dfc8713da150a_LightDiffuse_1, _AdditionalLights_53ace4769a03878cab4dfc8713da150a_Specular_2);
            float3 _ColorspaceConversion_094f58e30f03a482b38d714f1b72fe2d_Out_1;
            Unity_ColorspaceConversion_RGB_HSV_float(_AdditionalLights_53ace4769a03878cab4dfc8713da150a_LightDiffuse_1, _ColorspaceConversion_094f58e30f03a482b38d714f1b72fe2d_Out_1);
            float _Split_6a230abe7aa3cf818eee9b8259b924d5_R_1 = _ColorspaceConversion_094f58e30f03a482b38d714f1b72fe2d_Out_1[0];
            float _Split_6a230abe7aa3cf818eee9b8259b924d5_G_2 = _ColorspaceConversion_094f58e30f03a482b38d714f1b72fe2d_Out_1[1];
            float _Split_6a230abe7aa3cf818eee9b8259b924d5_B_3 = _ColorspaceConversion_094f58e30f03a482b38d714f1b72fe2d_Out_1[2];
            float _Split_6a230abe7aa3cf818eee9b8259b924d5_A_4 = 0;
            float4 _SampleGradient_31f89c9bf504f98e80e170e89328bcd5_Out_2;
            Unity_SampleGradientV0_float(NewGradient(1, 4, 2, float4(0, 0, 0, 0.001586938),float4(0.4339623, 0.4339623, 0.4339623, 0.2507973),float4(0.9056604, 0.9056604, 0.9056604, 0.317464),float4(1, 1, 1, 1),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0), float2(1, 0),float2(1, 1),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0)), _Split_6a230abe7aa3cf818eee9b8259b924d5_B_3, _SampleGradient_31f89c9bf504f98e80e170e89328bcd5_Out_2);
            float4 _Combine_d2b3f1197a27e889b1a337872c3276c5_RGBA_4;
            float3 _Combine_d2b3f1197a27e889b1a337872c3276c5_RGB_5;
            float2 _Combine_d2b3f1197a27e889b1a337872c3276c5_RG_6;
            Unity_Combine_float(_Split_6a230abe7aa3cf818eee9b8259b924d5_R_1, _Split_6a230abe7aa3cf818eee9b8259b924d5_G_2, (_SampleGradient_31f89c9bf504f98e80e170e89328bcd5_Out_2).x, 0, _Combine_d2b3f1197a27e889b1a337872c3276c5_RGBA_4, _Combine_d2b3f1197a27e889b1a337872c3276c5_RGB_5, _Combine_d2b3f1197a27e889b1a337872c3276c5_RG_6);
            float3 _ColorspaceConversion_3f2a3d424d0a9f88b24bbb224398188a_Out_1;
            Unity_ColorspaceConversion_HSV_RGB_float(_Combine_d2b3f1197a27e889b1a337872c3276c5_RGB_5, _ColorspaceConversion_3f2a3d424d0a9f88b24bbb224398188a_Out_1);
            float _Float_f19702ba0b98e5888235471ae5bbcb7a_Out_0 = 0.5;
            float3 _Step_88136ba2548b628faf27c254f446e6b1_Out_2;
            Unity_Step_float3((_Float_f19702ba0b98e5888235471ae5bbcb7a_Out_0.xxx), _AdditionalLights_53ace4769a03878cab4dfc8713da150a_Specular_2, _Step_88136ba2548b628faf27c254f446e6b1_Out_2);
            Lighting_1 = (float4(_ColorspaceConversion_3f2a3d424d0a9f88b24bbb224398188a_Out_1, 1.0));
            Specular_2 = (_Step_88136ba2548b628faf27c254f446e6b1_Out_2).x;
        }

        void Unity_BakedGIScale_float(float3 Normal, out float3 Out, float3 Position, float2 StaticUV, float2 DynamicUV)
        {
            Out = SHADERGRAPH_BAKED_GI(Position, Normal, StaticUV, DynamicUV, true);
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Preview_float3(float3 In, out float3 Out)
        {
            Out = In;
        }

        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }

        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }

        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }

        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }

        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }

        struct Bindings_MainLight_231093b74d3ab1341aa61c0ebb5d779d
        {
            float3 WorldSpaceNormal;
            float3 AbsoluteWorldSpacePosition;
        };

        void SG_MainLight_231093b74d3ab1341aa61c0ebb5d779d(Bindings_MainLight_231093b74d3ab1341aa61c0ebb5d779d IN, out float3 Direction_5, out float3 Color_1, out float ShadowAttenuation_2, out float SelfShadowing_3)
        {
            float3 _MainLightCustomFunction_99d870f0ed063d869021050fbb0ee9d1_Direction_1;
            float3 _MainLightCustomFunction_99d870f0ed063d869021050fbb0ee9d1_Color_2;
            float _MainLightCustomFunction_99d870f0ed063d869021050fbb0ee9d1_ShadowAtten_4;
            MainLight_float(IN.AbsoluteWorldSpacePosition, _MainLightCustomFunction_99d870f0ed063d869021050fbb0ee9d1_Direction_1, _MainLightCustomFunction_99d870f0ed063d869021050fbb0ee9d1_Color_2, _MainLightCustomFunction_99d870f0ed063d869021050fbb0ee9d1_ShadowAtten_4);
            float _DotProduct_bfdcc1a1ade4b288b1499497b4259bb3_Out_2;
            Unity_DotProduct_float3(_MainLightCustomFunction_99d870f0ed063d869021050fbb0ee9d1_Direction_1, IN.WorldSpaceNormal, _DotProduct_bfdcc1a1ade4b288b1499497b4259bb3_Out_2);
            float _Clamp_ff09e84cb5001e8cb35cb21d0f2584d0_Out_3;
            Unity_Clamp_float(_DotProduct_bfdcc1a1ade4b288b1499497b4259bb3_Out_2, 0, 1, _Clamp_ff09e84cb5001e8cb35cb21d0f2584d0_Out_3);
            Direction_5 = _MainLightCustomFunction_99d870f0ed063d869021050fbb0ee9d1_Direction_1;
            Color_1 = _MainLightCustomFunction_99d870f0ed063d869021050fbb0ee9d1_Color_2;
            ShadowAttenuation_2 = _MainLightCustomFunction_99d870f0ed063d869021050fbb0ee9d1_ShadowAtten_4;
            SelfShadowing_3 = _Clamp_ff09e84cb5001e8cb35cb21d0f2584d0_Out_3;
        }

        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }

        void Unity_Saturate_float4(float4 In, out float4 Out)
        {
            Out = saturate(In);
        }

        void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }

        void Unity_OneMinus_float3(float3 In, out float3 Out)
        {
            Out = 1 - In;
        }

        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }

        struct Bindings_ToonLightingModel_2146d4f705c217e489ca16fbb84d44d9
        {
            float3 WorldSpaceNormal;
            float3 WorldSpaceViewDirection;
            float3 WorldSpacePosition;
            float3 AbsoluteWorldSpacePosition;
            half4 uv1;
            half4 uv2;
        };

        void SG_ToonLightingModel_2146d4f705c217e489ca16fbb84d44d9(float Vector1_A5B15C15, Gradient Gradient, Bindings_ToonLightingModel_2146d4f705c217e489ca16fbb84d44d9 IN, out float3 LightingModel_1, out float3 DirectSpecular_2)
        {
            float3 _BakedGI_2fc8dd439fd7af858bca45c02f8205e5_Out_1;
            Unity_BakedGIScale_float(IN.WorldSpaceNormal, _BakedGI_2fc8dd439fd7af858bca45c02f8205e5_Out_1, IN.WorldSpacePosition, IN.uv1.xy, IN.uv2.xy);
            float3 _ColorspaceConversion_39b5e9ab1a693f8a8b5f8780b4557a5a_Out_1;
            Unity_ColorspaceConversion_RGB_HSV_float(_BakedGI_2fc8dd439fd7af858bca45c02f8205e5_Out_1, _ColorspaceConversion_39b5e9ab1a693f8a8b5f8780b4557a5a_Out_1);
            float _Split_17c82c905153718a82c3e81547a16132_R_1 = _ColorspaceConversion_39b5e9ab1a693f8a8b5f8780b4557a5a_Out_1[0];
            float _Split_17c82c905153718a82c3e81547a16132_G_2 = _ColorspaceConversion_39b5e9ab1a693f8a8b5f8780b4557a5a_Out_1[1];
            float _Split_17c82c905153718a82c3e81547a16132_B_3 = _ColorspaceConversion_39b5e9ab1a693f8a8b5f8780b4557a5a_Out_1[2];
            float _Split_17c82c905153718a82c3e81547a16132_A_4 = 0;
            float _Multiply_bb5fe1db3b24d58a930c409b314e8a1f_Out_2;
            Unity_Multiply_float(_Split_17c82c905153718a82c3e81547a16132_G_2, 0.8, _Multiply_bb5fe1db3b24d58a930c409b314e8a1f_Out_2);
            float4 _SampleGradient_0c59798543f6bb8391877046be0e8d38_Out_2;
            Unity_SampleGradientV0_float(NewGradient(0, 6, 2, float4(0.4245283, 0.4245283, 0.4245283, 0.02697795),float4(0.7169812, 0.7169812, 0.7169812, 0.1190509),float4(0.8, 0.8, 0.8, 0.1269856),float4(0.8, 0.8, 0.8, 0.4682536),float4(0.9339623, 0.9339623, 0.9339623, 0.482536),float4(1, 1, 1, 1),float4(0, 0, 0, 0),float4(0, 0, 0, 0), float2(1, 0),float2(1, 1),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0)), _Split_17c82c905153718a82c3e81547a16132_B_3, _SampleGradient_0c59798543f6bb8391877046be0e8d38_Out_2);
            float4 _Combine_f113b1ff984e6881bf4ea01c8f163f89_RGBA_4;
            float3 _Combine_f113b1ff984e6881bf4ea01c8f163f89_RGB_5;
            float2 _Combine_f113b1ff984e6881bf4ea01c8f163f89_RG_6;
            Unity_Combine_float(_Split_17c82c905153718a82c3e81547a16132_R_1, _Multiply_bb5fe1db3b24d58a930c409b314e8a1f_Out_2, (_SampleGradient_0c59798543f6bb8391877046be0e8d38_Out_2).x, 0, _Combine_f113b1ff984e6881bf4ea01c8f163f89_RGBA_4, _Combine_f113b1ff984e6881bf4ea01c8f163f89_RGB_5, _Combine_f113b1ff984e6881bf4ea01c8f163f89_RG_6);
            float3 _ColorspaceConversion_490f3af98e415f81986bac1bfa502488_Out_1;
            Unity_ColorspaceConversion_HSV_RGB_float(_Combine_f113b1ff984e6881bf4ea01c8f163f89_RGB_5, _ColorspaceConversion_490f3af98e415f81986bac1bfa502488_Out_1);
            float3 _Preview_c84d707aa5b6f789b87f63c48f13d20c_Out_1;
            Unity_Preview_float3(_ColorspaceConversion_490f3af98e415f81986bac1bfa502488_Out_1, _Preview_c84d707aa5b6f789b87f63c48f13d20c_Out_1);
            float _Distance_188c26489abaaa848b60159cd31736e6_Out_2;
            Unity_Distance_float3(_WorldSpaceCameraPos, IN.WorldSpacePosition, _Distance_188c26489abaaa848b60159cd31736e6_Out_2);
            float _Remap_456561369c4c1a8fa18a3a3f0e29fccb_Out_3;
            Unity_Remap_float(_Distance_188c26489abaaa848b60159cd31736e6_Out_2, float2 (20, 40), float2 (0, 1), _Remap_456561369c4c1a8fa18a3a3f0e29fccb_Out_3);
            float _Saturate_1e9bf8e2d2668a8295317d40dd582163_Out_1;
            Unity_Saturate_float(_Remap_456561369c4c1a8fa18a3a3f0e29fccb_Out_3, _Saturate_1e9bf8e2d2668a8295317d40dd582163_Out_1);
            Bindings_MainLight_231093b74d3ab1341aa61c0ebb5d779d _MainLight_2184fb120acd0b8bb1e6400cf2362966;
            _MainLight_2184fb120acd0b8bb1e6400cf2362966.WorldSpaceNormal = IN.WorldSpaceNormal;
            _MainLight_2184fb120acd0b8bb1e6400cf2362966.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            float3 _MainLight_2184fb120acd0b8bb1e6400cf2362966_Direction_5;
            float3 _MainLight_2184fb120acd0b8bb1e6400cf2362966_Color_1;
            float _MainLight_2184fb120acd0b8bb1e6400cf2362966_ShadowAttenuation_2;
            float _MainLight_2184fb120acd0b8bb1e6400cf2362966_SelfShadowing_3;
            SG_MainLight_231093b74d3ab1341aa61c0ebb5d779d(_MainLight_2184fb120acd0b8bb1e6400cf2362966, _MainLight_2184fb120acd0b8bb1e6400cf2362966_Direction_5, _MainLight_2184fb120acd0b8bb1e6400cf2362966_Color_1, _MainLight_2184fb120acd0b8bb1e6400cf2362966_ShadowAttenuation_2, _MainLight_2184fb120acd0b8bb1e6400cf2362966_SelfShadowing_3);
            float4 _SampleGradient_5e6f35a9f2bba886a09e3496a4971514_Out_2;
            Unity_SampleGradientV0_float(NewGradient(0, 2, 2, float4(0, 0, 0, 0.4117647),float4(1, 1, 1, 0.4529488),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0), float2(1, 0),float2(1, 1),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0)), _MainLight_2184fb120acd0b8bb1e6400cf2362966_ShadowAttenuation_2, _SampleGradient_5e6f35a9f2bba886a09e3496a4971514_Out_2);
            float4 _Add_1e98a3cd04cd39849e42734903bddba4_Out_2;
            Unity_Add_float4((_Saturate_1e9bf8e2d2668a8295317d40dd582163_Out_1.xxxx), _SampleGradient_5e6f35a9f2bba886a09e3496a4971514_Out_2, _Add_1e98a3cd04cd39849e42734903bddba4_Out_2);
            float4 _Saturate_3240b551a6d8b8869728be4cfdbe59ba_Out_1;
            Unity_Saturate_float4(_Add_1e98a3cd04cd39849e42734903bddba4_Out_2, _Saturate_3240b551a6d8b8869728be4cfdbe59ba_Out_1);
            float3 _Multiply_c83a20123005fe86956bbdd635820916_Out_2;
            Unity_Multiply_float(_Preview_c84d707aa5b6f789b87f63c48f13d20c_Out_1, (_Saturate_3240b551a6d8b8869728be4cfdbe59ba_Out_1.xyz), _Multiply_c83a20123005fe86956bbdd635820916_Out_2);
            float _Multiply_8a1616c99027a08c89dbe6ee9431dff8_Out_2;
            Unity_Multiply_float(_MainLight_2184fb120acd0b8bb1e6400cf2362966_ShadowAttenuation_2, _MainLight_2184fb120acd0b8bb1e6400cf2362966_SelfShadowing_3, _Multiply_8a1616c99027a08c89dbe6ee9431dff8_Out_2);
            float4 _SampleGradient_b3c4fcbeaf5fbc8faf3b3e3c9a817008_Out_2;
            Unity_SampleGradientV0_float(NewGradient(0, 3, 2, float4(0.6037736, 0.6037736, 0.6037736, 0.4588235),float4(1, 1, 1, 0.4952316),float4(1, 1, 1, 1),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0), float2(1, 0),float2(1, 1),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0)), _Multiply_8a1616c99027a08c89dbe6ee9431dff8_Out_2, _SampleGradient_b3c4fcbeaf5fbc8faf3b3e3c9a817008_Out_2);
            float3 _Multiply_128d1fd95c401d8b899cab5f1390d224_Out_2;
            Unity_Multiply_float(_MainLight_2184fb120acd0b8bb1e6400cf2362966_Color_1, (_SampleGradient_b3c4fcbeaf5fbc8faf3b3e3c9a817008_Out_2.xyz), _Multiply_128d1fd95c401d8b899cab5f1390d224_Out_2);
            float _Float_a777f4e22dca81818a73c7929417c54f_Out_0 = 8;
            float3 _BakedGI_e1a2de84e6de3186be2da7d3db9d3453_Out_1;
            Unity_BakedGIScale_float(IN.WorldSpaceNormal, _BakedGI_e1a2de84e6de3186be2da7d3db9d3453_Out_1, IN.WorldSpacePosition, IN.uv1.xy, IN.uv2.xy);
            float3 _Multiply_d1c43dbcaf1eb48da57cb272dc2ed065_Out_2;
            Unity_Multiply_float((_Float_a777f4e22dca81818a73c7929417c54f_Out_0.xxx), _BakedGI_e1a2de84e6de3186be2da7d3db9d3453_Out_1, _Multiply_d1c43dbcaf1eb48da57cb272dc2ed065_Out_2);
            float3 _OneMinus_3955ed2b9057b685a37681dfd9b6f211_Out_1;
            Unity_OneMinus_float3(_Multiply_d1c43dbcaf1eb48da57cb272dc2ed065_Out_2, _OneMinus_3955ed2b9057b685a37681dfd9b6f211_Out_1);
            float3 _Step_d362b443237aed86a6b0e17fa99a64f5_Out_2;
            Unity_Step_float3(float3(1, 1, 1), _OneMinus_3955ed2b9057b685a37681dfd9b6f211_Out_1, _Step_d362b443237aed86a6b0e17fa99a64f5_Out_2);
            float3 _Add_88ea69e3d3f35e849b283907f55b9b17_Out_2;
            Unity_Add_float3(_Multiply_d1c43dbcaf1eb48da57cb272dc2ed065_Out_2, _Step_d362b443237aed86a6b0e17fa99a64f5_Out_2, _Add_88ea69e3d3f35e849b283907f55b9b17_Out_2);
            float3 _Multiply_cc3e6860fcb3de87b328e84b1eaeb395_Out_2;
            Unity_Multiply_float(_Multiply_128d1fd95c401d8b899cab5f1390d224_Out_2, _Add_88ea69e3d3f35e849b283907f55b9b17_Out_2, _Multiply_cc3e6860fcb3de87b328e84b1eaeb395_Out_2);
            #if defined(LIGHTMAP_ON)
            float3 _LIGHTMAP_0458efac5733c08fac8ebb6d98c10400_Out_0 = _Multiply_c83a20123005fe86956bbdd635820916_Out_2;
            #else
            float3 _LIGHTMAP_0458efac5733c08fac8ebb6d98c10400_Out_0 = _Multiply_cc3e6860fcb3de87b328e84b1eaeb395_Out_2;
            #endif
            float _Float_3faea16334e5ea86bcfca1b344a57be6_Out_0 = 0.5;
            float _Property_98501e3bb2eab28281b6849962299943_Out_0 = Vector1_A5B15C15;
            Bindings_MainLight_231093b74d3ab1341aa61c0ebb5d779d _MainLight_612e63efb8e4d08eb5027337e48edab0;
            _MainLight_612e63efb8e4d08eb5027337e48edab0.WorldSpaceNormal = IN.WorldSpaceNormal;
            _MainLight_612e63efb8e4d08eb5027337e48edab0.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            float3 _MainLight_612e63efb8e4d08eb5027337e48edab0_Direction_5;
            float3 _MainLight_612e63efb8e4d08eb5027337e48edab0_Color_1;
            float _MainLight_612e63efb8e4d08eb5027337e48edab0_ShadowAttenuation_2;
            float _MainLight_612e63efb8e4d08eb5027337e48edab0_SelfShadowing_3;
            SG_MainLight_231093b74d3ab1341aa61c0ebb5d779d(_MainLight_612e63efb8e4d08eb5027337e48edab0, _MainLight_612e63efb8e4d08eb5027337e48edab0_Direction_5, _MainLight_612e63efb8e4d08eb5027337e48edab0_Color_1, _MainLight_612e63efb8e4d08eb5027337e48edab0_ShadowAttenuation_2, _MainLight_612e63efb8e4d08eb5027337e48edab0_SelfShadowing_3);
            float3 _DirectSpecularCustomFunction_fcd2160ad70d8e8e8d394854e83d1cdc_Out_6;
            DirectSpecular_float(_Property_98501e3bb2eab28281b6849962299943_Out_0, _MainLight_612e63efb8e4d08eb5027337e48edab0_Direction_5, IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _DirectSpecularCustomFunction_fcd2160ad70d8e8e8d394854e83d1cdc_Out_6);
            float3 _Step_7e7270f34eb9ae88a28eb398c87a6389_Out_2;
            Unity_Step_float3((_Float_3faea16334e5ea86bcfca1b344a57be6_Out_0.xxx), _DirectSpecularCustomFunction_fcd2160ad70d8e8e8d394854e83d1cdc_Out_6, _Step_7e7270f34eb9ae88a28eb398c87a6389_Out_2);
            LightingModel_1 = _LIGHTMAP_0458efac5733c08fac8ebb6d98c10400_Out_0;
            DirectSpecular_2 = _Step_7e7270f34eb9ae88a28eb398c87a6389_Out_2;
        }

        void Unity_Clamp_float3(float3 In, float3 Min, float3 Max, out float3 Out)
        {
            Out = clamp(In, Min, Max);
        }

        struct Bindings_ToonShading_fbed86498f4059d42b9f1788c6dee1c2
        {
            float3 WorldSpaceNormal;
            float3 WorldSpaceViewDirection;
            float3 WorldSpacePosition;
            float3 AbsoluteWorldSpacePosition;
            half4 uv1;
            half4 uv2;
        };

        void SG_ToonShading_fbed86498f4059d42b9f1788c6dee1c2(float4 Color_601E5129, UnityTexture2D Texture2D_75C45C06, float3 Vector3_E2B204B9, Bindings_ToonShading_fbed86498f4059d42b9f1788c6dee1c2 IN, out float3 ShadingResult_1)
        {
            float _Float_957c6dcfd7ff405b940fb124530373ec_Out_0 = 1;
            Bindings_AdditionalLightsToon_87dc85b7edc8a8442adaa8215da4c975 _AdditionalLightsToon_522d6f0fce516085857775d629693765;
            _AdditionalLightsToon_522d6f0fce516085857775d629693765.WorldSpaceNormal = IN.WorldSpaceNormal;
            _AdditionalLightsToon_522d6f0fce516085857775d629693765.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
            _AdditionalLightsToon_522d6f0fce516085857775d629693765.WorldSpacePosition = IN.WorldSpacePosition;
            float4 _AdditionalLightsToon_522d6f0fce516085857775d629693765_Lighting_1;
            float _AdditionalLightsToon_522d6f0fce516085857775d629693765_Specular_2;
            SG_AdditionalLightsToon_87dc85b7edc8a8442adaa8215da4c975(_Float_957c6dcfd7ff405b940fb124530373ec_Out_0, _AdditionalLightsToon_522d6f0fce516085857775d629693765, _AdditionalLightsToon_522d6f0fce516085857775d629693765_Lighting_1, _AdditionalLightsToon_522d6f0fce516085857775d629693765_Specular_2);
            float _Float_dd45c170d5cc40768ba48fa24fb48c8f_Out_0 = 1;
            Bindings_ToonLightingModel_2146d4f705c217e489ca16fbb84d44d9 _ToonLightingModel_476222baf740f884bb3c8037fd266322;
            _ToonLightingModel_476222baf740f884bb3c8037fd266322.WorldSpaceNormal = IN.WorldSpaceNormal;
            _ToonLightingModel_476222baf740f884bb3c8037fd266322.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
            _ToonLightingModel_476222baf740f884bb3c8037fd266322.WorldSpacePosition = IN.WorldSpacePosition;
            _ToonLightingModel_476222baf740f884bb3c8037fd266322.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _ToonLightingModel_476222baf740f884bb3c8037fd266322.uv1 = IN.uv1;
            _ToonLightingModel_476222baf740f884bb3c8037fd266322.uv2 = IN.uv2;
            float3 _ToonLightingModel_476222baf740f884bb3c8037fd266322_LightingModel_1;
            float3 _ToonLightingModel_476222baf740f884bb3c8037fd266322_DirectSpecular_2;
            SG_ToonLightingModel_2146d4f705c217e489ca16fbb84d44d9(_Float_dd45c170d5cc40768ba48fa24fb48c8f_Out_0, NewGradient(1, 2, 2, float4(0, 0, 0, 0.01765469),float4(1, 1, 1, 1),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0), float2(1, 0),float2(1, 1),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0)), _ToonLightingModel_476222baf740f884bb3c8037fd266322, _ToonLightingModel_476222baf740f884bb3c8037fd266322_LightingModel_1, _ToonLightingModel_476222baf740f884bb3c8037fd266322_DirectSpecular_2);
            float3 _Add_63ee59e9ed8fcf82a40b6aff5d953a99_Out_2;
            Unity_Add_float3((_AdditionalLightsToon_522d6f0fce516085857775d629693765_Lighting_1.xyz), _ToonLightingModel_476222baf740f884bb3c8037fd266322_LightingModel_1, _Add_63ee59e9ed8fcf82a40b6aff5d953a99_Out_2);
            float3 _Property_51958772a319f88ca40c9bd6c3e4b814_Out_0 = Vector3_E2B204B9;
            float3 _Multiply_baab89e83466a88896036c96ab698f59_Out_2;
            Unity_Multiply_float(_Add_63ee59e9ed8fcf82a40b6aff5d953a99_Out_2, _Property_51958772a319f88ca40c9bd6c3e4b814_Out_0, _Multiply_baab89e83466a88896036c96ab698f59_Out_2);
            float4 _Property_ccfc64e126740e8289b25ec5613bda25_Out_0 = Color_601E5129;
            float _Split_51b72309f11b548283f9cb1a349bc6cf_R_1 = _Property_ccfc64e126740e8289b25ec5613bda25_Out_0[0];
            float _Split_51b72309f11b548283f9cb1a349bc6cf_G_2 = _Property_ccfc64e126740e8289b25ec5613bda25_Out_0[1];
            float _Split_51b72309f11b548283f9cb1a349bc6cf_B_3 = _Property_ccfc64e126740e8289b25ec5613bda25_Out_0[2];
            float _Split_51b72309f11b548283f9cb1a349bc6cf_A_4 = _Property_ccfc64e126740e8289b25ec5613bda25_Out_0[3];
            float3 _Vector3_7a9f39ede9f8948e88125976a1214728_Out_0 = float3(_Split_51b72309f11b548283f9cb1a349bc6cf_R_1, _Split_51b72309f11b548283f9cb1a349bc6cf_G_2, _Split_51b72309f11b548283f9cb1a349bc6cf_B_3);
            float3 _Multiply_9494ae00673c7282907e8c76bb19793a_Out_2;
            Unity_Multiply_float(_Vector3_7a9f39ede9f8948e88125976a1214728_Out_0, (_Split_51b72309f11b548283f9cb1a349bc6cf_A_4.xxx), _Multiply_9494ae00673c7282907e8c76bb19793a_Out_2);
            float3 _Add_90a11d4d8624d78a8cc2b8293f17fbe3_Out_2;
            Unity_Add_float3((_AdditionalLightsToon_522d6f0fce516085857775d629693765_Specular_2.xxx), _ToonLightingModel_476222baf740f884bb3c8037fd266322_DirectSpecular_2, _Add_90a11d4d8624d78a8cc2b8293f17fbe3_Out_2);
            float3 _Clamp_7de4925c649a8381a10a18afb8a48879_Out_3;
            Unity_Clamp_float3(_Add_90a11d4d8624d78a8cc2b8293f17fbe3_Out_2, float3(0, 0, 0), float3(1, 1, 1), _Clamp_7de4925c649a8381a10a18afb8a48879_Out_3);
            float3 _Multiply_86dfcce011f566839411f5596d36053f_Out_2;
            Unity_Multiply_float(_Multiply_9494ae00673c7282907e8c76bb19793a_Out_2, _Clamp_7de4925c649a8381a10a18afb8a48879_Out_3, _Multiply_86dfcce011f566839411f5596d36053f_Out_2);
            float3 _Add_13f444047663e480b82dc115de4795ca_Out_2;
            Unity_Add_float3(_Multiply_baab89e83466a88896036c96ab698f59_Out_2, _Multiply_86dfcce011f566839411f5596d36053f_Out_2, _Add_13f444047663e480b82dc115de4795ca_Out_2);
            ShadingResult_1 = _Add_13f444047663e480b82dc115de4795ca_Out_2;
        }

        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }

        void Unity_Subtract_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A - B;
        }

        void Unity_Length_float3(float3 In, out float Out)
        {
            Out = length(In);
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }

        void Unity_Floor_float(float In, out float Out)
        {
            Out = floor(In);
        }

        // 89be1983e036822f20a5ab757382b6d4
        #include "Assets/Shaders/CustomHLSL/Outline.hlsl"

        void Unity_Ceiling_float(float In, out float Out)
        {
            Out = ceil(In);
        }

        void Unity_Modulo_float(float A, float B, out float Out)
        {
            Out = fmod(A, B);
        }

        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }

        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }

        struct Bindings_Outline_36b1cdb3a2e056742ae9eed5db1cbfe9
        {
            float3 WorldSpacePosition;
            float4 ScreenPosition;
        };

        void SG_Outline_36b1cdb3a2e056742ae9eed5db1cbfe9(float Vector1_688861A9, float Vector1_E39B1B65, float Vector1_903A7FAB, Bindings_Outline_36b1cdb3a2e056742ae9eed5db1cbfe9 IN, out float Outlline_1)
        {
            float4 _ScreenPosition_2e560ddf91b3468b8f40c9b2c72d11c5_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
            float _Property_26b7060b4226f78a86a79767631afeef_Out_0 = Vector1_688861A9;
            float _Multiply_8ab15267716c0b81814f860a0bd0bd19_Out_2;
            Unity_Multiply_float(_Property_26b7060b4226f78a86a79767631afeef_Out_0, _ScreenParams.y, _Multiply_8ab15267716c0b81814f860a0bd0bd19_Out_2);
            float _Divide_58e8ef83aabb3c8e9a5938f52a3624ed_Out_2;
            Unity_Divide_float(_Multiply_8ab15267716c0b81814f860a0bd0bd19_Out_2, 1080, _Divide_58e8ef83aabb3c8e9a5938f52a3624ed_Out_2);
            float3 _Subtract_d634f3591866848e9c300d1b7f23c921_Out_2;
            Unity_Subtract_float3(IN.WorldSpacePosition, _WorldSpaceCameraPos, _Subtract_d634f3591866848e9c300d1b7f23c921_Out_2);
            float _Length_e0ffd3cf0df2d68b8a670ae08cc28a3f_Out_1;
            Unity_Length_float3(_Subtract_d634f3591866848e9c300d1b7f23c921_Out_2, _Length_e0ffd3cf0df2d68b8a670ae08cc28a3f_Out_1);
            float _Divide_76fd1406d293838a8413fcd681b20910_Out_2;
            Unity_Divide_float(_Length_e0ffd3cf0df2d68b8a670ae08cc28a3f_Out_1, 1000, _Divide_76fd1406d293838a8413fcd681b20910_Out_2);
            float _Subtract_2fe6a26a0c8a1280b0e4224ea52ca2d8_Out_2;
            Unity_Subtract_float(_Divide_58e8ef83aabb3c8e9a5938f52a3624ed_Out_2, _Divide_76fd1406d293838a8413fcd681b20910_Out_2, _Subtract_2fe6a26a0c8a1280b0e4224ea52ca2d8_Out_2);
            float _Clamp_ce27b759e9ff7a8191c59b19863f4ac0_Out_3;
            Unity_Clamp_float(_Subtract_2fe6a26a0c8a1280b0e4224ea52ca2d8_Out_2, 0, 50, _Clamp_ce27b759e9ff7a8191c59b19863f4ac0_Out_3);
            float _Floor_eb6a8290b997f582b5a5153d37f208d9_Out_1;
            Unity_Floor_float(_Clamp_ce27b759e9ff7a8191c59b19863f4ac0_Out_3, _Floor_eb6a8290b997f582b5a5153d37f208d9_Out_1);
            float _Property_fb2872ce9136f78a9750eed9f9011bcb_Out_0 = Vector1_E39B1B65;
            float _Property_0ad5d56ece29ec87a10b165888e2439d_Out_0 = Vector1_903A7FAB;
            float _OutlineObjectCustomFunction_ceba13a364372e858a1bd1283e57e3c8_Out_4;
            OutlineObject_float((_ScreenPosition_2e560ddf91b3468b8f40c9b2c72d11c5_Out_0.xy), _Floor_eb6a8290b997f582b5a5153d37f208d9_Out_1, _Property_fb2872ce9136f78a9750eed9f9011bcb_Out_0, _Property_0ad5d56ece29ec87a10b165888e2439d_Out_0, _OutlineObjectCustomFunction_ceba13a364372e858a1bd1283e57e3c8_Out_4);
            float4 _ScreenPosition_50303d2a4e3cf185981701786c945521_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
            float _Ceiling_f7dc6733b588538ab2f5fd7563ac8c7d_Out_1;
            Unity_Ceiling_float(_Clamp_ce27b759e9ff7a8191c59b19863f4ac0_Out_3, _Ceiling_f7dc6733b588538ab2f5fd7563ac8c7d_Out_1);
            float _Property_db9d2355347f3c808f2ba2909ffd1167_Out_0 = Vector1_E39B1B65;
            float _Property_dc32a5e5d4696f8b8fb2ca945f29535c_Out_0 = Vector1_903A7FAB;
            float _OutlineObjectCustomFunction_03f1257844d67c88b0c87c59c190780d_Out_4;
            OutlineObject_float((_ScreenPosition_50303d2a4e3cf185981701786c945521_Out_0.xy), _Ceiling_f7dc6733b588538ab2f5fd7563ac8c7d_Out_1, _Property_db9d2355347f3c808f2ba2909ffd1167_Out_0, _Property_dc32a5e5d4696f8b8fb2ca945f29535c_Out_0, _OutlineObjectCustomFunction_03f1257844d67c88b0c87c59c190780d_Out_4);
            float _Modulo_6413c6dd820a908299f9d6d1e31e6b6d_Out_2;
            Unity_Modulo_float(_Clamp_ce27b759e9ff7a8191c59b19863f4ac0_Out_3, 1, _Modulo_6413c6dd820a908299f9d6d1e31e6b6d_Out_2);
            float _Lerp_67c8f4bfd2e0e085b2a615ef2a29899f_Out_3;
            Unity_Lerp_float(_OutlineObjectCustomFunction_ceba13a364372e858a1bd1283e57e3c8_Out_4, _OutlineObjectCustomFunction_03f1257844d67c88b0c87c59c190780d_Out_4, _Modulo_6413c6dd820a908299f9d6d1e31e6b6d_Out_2, _Lerp_67c8f4bfd2e0e085b2a615ef2a29899f_Out_3);
            float _OneMinus_8716b951fb801c838f0b39eca5425cfe_Out_1;
            Unity_OneMinus_float(_Lerp_67c8f4bfd2e0e085b2a615ef2a29899f_Out_3, _OneMinus_8716b951fb801c838f0b39eca5425cfe_Out_1);
            Outlline_1 = _OneMinus_8716b951fb801c838f0b39eca5425cfe_Out_1;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 _Property_a60ed4f8ff52fc829b1ab2f22f5df14b_Out_0 = _SpecularColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            UnityTexture2D _Property_b1224cdeaf4cdb82aec016db3e3c06ec_Out_0 = UnityBuildTexture2DStructNoScale(_SpecularMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 _Property_0c463843746e288391b8f14568c1b226_Out_0 = _MainColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            UnityTexture2D _Property_e2d0c96d6ea00780805055033bae5838_Out_0 = UnityBuildTexture2DStructNoScale(_MainTexture);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float2 _Property_b1ef9ff04e418d8ca08a9d853ebb74fb_Out_0 = _Tiling;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float2 _Property_476ca1516c65628ba31419a95cbea98c_Out_0 = _Offset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            Bindings_Albedo_e5a8c819ad3623244a943a45dac4ffa4 _Albedo_cf2dc1721f2db789a4f0673fe3b88499;
            _Albedo_cf2dc1721f2db789a4f0673fe3b88499.uv0 = IN.uv0;
            float4 _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1;
            SG_Albedo_e5a8c819ad3623244a943a45dac4ffa4(_Property_0c463843746e288391b8f14568c1b226_Out_0, _Property_e2d0c96d6ea00780805055033bae5838_Out_0, _Property_b1ef9ff04e418d8ca08a9d853ebb74fb_Out_0, _Property_476ca1516c65628ba31419a95cbea98c_Out_0, _Albedo_cf2dc1721f2db789a4f0673fe3b88499, _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            Bindings_ToonShading_fbed86498f4059d42b9f1788c6dee1c2 _ToonShading_bb6f3ca58f75fe85a94ffe9040f484e4;
            _ToonShading_bb6f3ca58f75fe85a94ffe9040f484e4.WorldSpaceNormal = IN.WorldSpaceNormal;
            _ToonShading_bb6f3ca58f75fe85a94ffe9040f484e4.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
            _ToonShading_bb6f3ca58f75fe85a94ffe9040f484e4.WorldSpacePosition = IN.WorldSpacePosition;
            _ToonShading_bb6f3ca58f75fe85a94ffe9040f484e4.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _ToonShading_bb6f3ca58f75fe85a94ffe9040f484e4.uv1 = IN.uv1;
            _ToonShading_bb6f3ca58f75fe85a94ffe9040f484e4.uv2 = IN.uv2;
            float3 _ToonShading_bb6f3ca58f75fe85a94ffe9040f484e4_ShadingResult_1;
            SG_ToonShading_fbed86498f4059d42b9f1788c6dee1c2(_Property_a60ed4f8ff52fc829b1ab2f22f5df14b_Out_0, _Property_b1224cdeaf4cdb82aec016db3e3c06ec_Out_0, (_Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1.xyz), _ToonShading_bb6f3ca58f75fe85a94ffe9040f484e4, _ToonShading_bb6f3ca58f75fe85a94ffe9040f484e4_ShadingResult_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float _Property_6703ef29918b648193c61392b2b9e0f6_Out_0 = _OutlineThickness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float _Property_7dcffaf848e6eb80bac7964c2b25e439_Out_0 = _OutlineDepthSensitivity;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float _Property_cf5c51345dbc1988b2c3407a0cf5af74_Out_0 = _OutlineNormalsSensitivity;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            Bindings_Outline_36b1cdb3a2e056742ae9eed5db1cbfe9 _Outline_fb356922aae02284b26b678290594e65;
            _Outline_fb356922aae02284b26b678290594e65.WorldSpacePosition = IN.WorldSpacePosition;
            _Outline_fb356922aae02284b26b678290594e65.ScreenPosition = IN.ScreenPosition;
            float _Outline_fb356922aae02284b26b678290594e65_Outlline_1;
            SG_Outline_36b1cdb3a2e056742ae9eed5db1cbfe9(_Property_6703ef29918b648193c61392b2b9e0f6_Out_0, _Property_7dcffaf848e6eb80bac7964c2b25e439_Out_0, _Property_cf5c51345dbc1988b2c3407a0cf5af74_Out_0, _Outline_fb356922aae02284b26b678290594e65, _Outline_fb356922aae02284b26b678290594e65_Outlline_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 _Multiply_b922bfeebbb4f984b7008c5cf9a6a9ae_Out_2;
            Unity_Multiply_float(_ToonShading_bb6f3ca58f75fe85a94ffe9040f484e4_ShadingResult_1, (_Outline_fb356922aae02284b26b678290594e65_Outlline_1.xxx), _Multiply_b922bfeebbb4f984b7008c5cf9a6a9ae_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float _Split_7b58296a546e388389f1dca27ac980fb_R_1 = _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1[0];
            float _Split_7b58296a546e388389f1dca27ac980fb_G_2 = _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1[1];
            float _Split_7b58296a546e388389f1dca27ac980fb_B_3 = _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1[2];
            float _Split_7b58296a546e388389f1dca27ac980fb_A_4 = _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1[3];
            #endif
            surface.BaseColor = _Multiply_b922bfeebbb4f984b7008c5cf9a6a9ae_Out_2;
            surface.Alpha = _Split_7b58296a546e388389f1dca27ac980fb_A_4;
            surface.AlphaClipThreshold = 0.5;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.ObjectSpaceNormal =           input.normalOS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.ObjectSpaceTangent =          input.tangentOS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.ObjectSpacePosition =         input.positionOS;
        #endif


            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        float3 unnormalizedNormalWS = input.normalWS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        #endif



        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.WorldSpaceNormal =            renormFactor*input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        #endif



        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.WorldSpaceViewDirection =     input.viewDirectionWS; //TODO: by default normalized in HD, but not in universal
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.WorldSpacePosition =          input.positionWS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionWS);
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.uv0 =                         input.texCoord0;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.uv1 =                         input.texCoord1;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.uv2 =                         input.texCoord2;
        #endif

        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        ColorMask 0

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            #pragma multi_compile _ _CASTING_PUNCTUAL_LIGHT_SHADOW
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
        #pragma multi_compile _ _SHADOWS_SOFT
        #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile _ LIGHTMAP_ON

        #if defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_1
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_2
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT)
            #define KEYWORD_PERMUTATION_3
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_4
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_5
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_6
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE)
            #define KEYWORD_PERMUTATION_7
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_8
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_9
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_SHADOWS_SOFT) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_10
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_SHADOWS_SOFT)
            #define KEYWORD_PERMUTATION_11
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_12
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_13
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_14
        #elif defined(_MAIN_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_15
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_16
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_17
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_18
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT)
            #define KEYWORD_PERMUTATION_19
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_20
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_21
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_22
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE)
            #define KEYWORD_PERMUTATION_23
        #elif defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_24
        #elif defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_25
        #elif defined(_SHADOWS_SOFT) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_26
        #elif defined(_SHADOWS_SOFT)
            #define KEYWORD_PERMUTATION_27
        #elif defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_28
        #elif defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_29
        #elif defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_30
        #else
            #define KEYWORD_PERMUTATION_31
        #endif


            // Defines
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define _AlphaClip 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define ATTRIBUTES_NEED_NORMAL
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define ATTRIBUTES_NEED_TANGENT
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define VARYINGS_NEED_TEXCOORD0
        #endif

            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_SHADOWCASTER
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 uv0 : TEXCOORD0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 texCoord0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 uv0;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 interp0 : TEXCOORD0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };

            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _MainColor;
        float4 _MainTexture_TexelSize;
        float _Smoothness;
        float4 _SpecularColor;
        float4 _SpecularMap_TexelSize;
        float _OutlineThickness;
        float _OutlineDepthSensitivity;
        float _OutlineNormalsSensitivity;
        float2 _Tiling;
        float2 _Offset;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTexture);
        SAMPLER(sampler_MainTexture);
        TEXTURE2D(_SpecularMap);
        SAMPLER(sampler_SpecularMap);

            // Graph Functions
            
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        struct Bindings_Albedo_e5a8c819ad3623244a943a45dac4ffa4
        {
            half4 uv0;
        };

        void SG_Albedo_e5a8c819ad3623244a943a45dac4ffa4(float4 Vector4_12A72EFC, UnityTexture2D Texture2D_9644D008, float2 Vector2_E2350C2, float2 Vector2_D0710BCD, Bindings_Albedo_e5a8c819ad3623244a943a45dac4ffa4 IN, out float4 AlbedoTransp_1)
        {
            float4 _Property_ead5a42fe40ddf8890ef8f59627dbf00_Out_0 = Vector4_12A72EFC;
            float _Split_eefb1b94fc79aa81969b28152339aaa5_R_1 = _Property_ead5a42fe40ddf8890ef8f59627dbf00_Out_0[0];
            float _Split_eefb1b94fc79aa81969b28152339aaa5_G_2 = _Property_ead5a42fe40ddf8890ef8f59627dbf00_Out_0[1];
            float _Split_eefb1b94fc79aa81969b28152339aaa5_B_3 = _Property_ead5a42fe40ddf8890ef8f59627dbf00_Out_0[2];
            float _Split_eefb1b94fc79aa81969b28152339aaa5_A_4 = _Property_ead5a42fe40ddf8890ef8f59627dbf00_Out_0[3];
            float4 _Combine_0989ac05ac713585b1970bd9dce2d35a_RGBA_4;
            float3 _Combine_0989ac05ac713585b1970bd9dce2d35a_RGB_5;
            float2 _Combine_0989ac05ac713585b1970bd9dce2d35a_RG_6;
            Unity_Combine_float(_Split_eefb1b94fc79aa81969b28152339aaa5_R_1, _Split_eefb1b94fc79aa81969b28152339aaa5_G_2, _Split_eefb1b94fc79aa81969b28152339aaa5_B_3, 1, _Combine_0989ac05ac713585b1970bd9dce2d35a_RGBA_4, _Combine_0989ac05ac713585b1970bd9dce2d35a_RGB_5, _Combine_0989ac05ac713585b1970bd9dce2d35a_RG_6);
            UnityTexture2D _Property_c6a26ce271d98f84bb13cd7ce0ae398d_Out_0 = Texture2D_9644D008;
            float2 _Property_fe6e35ca6b347f83a931216e0b119ec0_Out_0 = Vector2_E2350C2;
            float2 _Property_422e593a494f798fbe504a4f2b01c59a_Out_0 = Vector2_D0710BCD;
            float2 _TilingAndOffset_7708bc2bff71f48e91e0337bac4a6137_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_fe6e35ca6b347f83a931216e0b119ec0_Out_0, _Property_422e593a494f798fbe504a4f2b01c59a_Out_0, _TilingAndOffset_7708bc2bff71f48e91e0337bac4a6137_Out_3);
            float4 _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c6a26ce271d98f84bb13cd7ce0ae398d_Out_0.tex, _Property_c6a26ce271d98f84bb13cd7ce0ae398d_Out_0.samplerstate, _TilingAndOffset_7708bc2bff71f48e91e0337bac4a6137_Out_3);
            float _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_R_4 = _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0.r;
            float _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_G_5 = _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0.g;
            float _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_B_6 = _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0.b;
            float _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_A_7 = _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0.a;
            float4 _Multiply_2bed8dfc9ac182839f4890b363090fbe_Out_2;
            Unity_Multiply_float(_Combine_0989ac05ac713585b1970bd9dce2d35a_RGBA_4, _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0, _Multiply_2bed8dfc9ac182839f4890b363090fbe_Out_2);
            AlbedoTransp_1 = _Multiply_2bed8dfc9ac182839f4890b363090fbe_Out_2;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 _Property_0c463843746e288391b8f14568c1b226_Out_0 = _MainColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            UnityTexture2D _Property_e2d0c96d6ea00780805055033bae5838_Out_0 = UnityBuildTexture2DStructNoScale(_MainTexture);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float2 _Property_b1ef9ff04e418d8ca08a9d853ebb74fb_Out_0 = _Tiling;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float2 _Property_476ca1516c65628ba31419a95cbea98c_Out_0 = _Offset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            Bindings_Albedo_e5a8c819ad3623244a943a45dac4ffa4 _Albedo_cf2dc1721f2db789a4f0673fe3b88499;
            _Albedo_cf2dc1721f2db789a4f0673fe3b88499.uv0 = IN.uv0;
            float4 _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1;
            SG_Albedo_e5a8c819ad3623244a943a45dac4ffa4(_Property_0c463843746e288391b8f14568c1b226_Out_0, _Property_e2d0c96d6ea00780805055033bae5838_Out_0, _Property_b1ef9ff04e418d8ca08a9d853ebb74fb_Out_0, _Property_476ca1516c65628ba31419a95cbea98c_Out_0, _Albedo_cf2dc1721f2db789a4f0673fe3b88499, _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float _Split_7b58296a546e388389f1dca27ac980fb_R_1 = _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1[0];
            float _Split_7b58296a546e388389f1dca27ac980fb_G_2 = _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1[1];
            float _Split_7b58296a546e388389f1dca27ac980fb_B_3 = _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1[2];
            float _Split_7b58296a546e388389f1dca27ac980fb_A_4 = _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1[3];
            #endif
            surface.Alpha = _Split_7b58296a546e388389f1dca27ac980fb_A_4;
            surface.AlphaClipThreshold = 0.5;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.ObjectSpaceNormal =           input.normalOS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.ObjectSpaceTangent =          input.tangentOS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.ObjectSpacePosition =         input.positionOS;
        #endif


            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.uv0 =                         input.texCoord0;
        #endif

        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "DepthOnly"
            Tags
            {
                "LightMode" = "DepthOnly"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        ColorMask 0

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
        #pragma multi_compile _ _SHADOWS_SOFT
        #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile _ LIGHTMAP_ON

        #if defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_1
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_2
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT)
            #define KEYWORD_PERMUTATION_3
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_4
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_5
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_6
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_MAIN_LIGHT_SHADOWS_CASCADE)
            #define KEYWORD_PERMUTATION_7
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_8
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_9
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_SHADOWS_SOFT) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_10
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_SHADOWS_SOFT)
            #define KEYWORD_PERMUTATION_11
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_12
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_13
        #elif defined(_MAIN_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_14
        #elif defined(_MAIN_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_15
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_16
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_17
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_18
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_SHADOWS_SOFT)
            #define KEYWORD_PERMUTATION_19
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_20
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_21
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_22
        #elif defined(_MAIN_LIGHT_SHADOWS_CASCADE)
            #define KEYWORD_PERMUTATION_23
        #elif defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_24
        #elif defined(_SHADOWS_SOFT) && defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_25
        #elif defined(_SHADOWS_SOFT) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_26
        #elif defined(_SHADOWS_SOFT)
            #define KEYWORD_PERMUTATION_27
        #elif defined(_ADDITIONAL_LIGHT_SHADOWS) && defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_28
        #elif defined(_ADDITIONAL_LIGHT_SHADOWS)
            #define KEYWORD_PERMUTATION_29
        #elif defined(LIGHTMAP_ON)
            #define KEYWORD_PERMUTATION_30
        #else
            #define KEYWORD_PERMUTATION_31
        #endif


            // Defines
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define _AlphaClip 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define ATTRIBUTES_NEED_NORMAL
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define ATTRIBUTES_NEED_TANGENT
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        #define VARYINGS_NEED_TEXCOORD0
        #endif

            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHONLY
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 uv0 : TEXCOORD0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 texCoord0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 uv0;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 interp0 : TEXCOORD0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };

            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float4 _MainColor;
        float4 _MainTexture_TexelSize;
        float _Smoothness;
        float4 _SpecularColor;
        float4 _SpecularMap_TexelSize;
        float _OutlineThickness;
        float _OutlineDepthSensitivity;
        float _OutlineNormalsSensitivity;
        float2 _Tiling;
        float2 _Offset;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTexture);
        SAMPLER(sampler_MainTexture);
        TEXTURE2D(_SpecularMap);
        SAMPLER(sampler_SpecularMap);

            // Graph Functions
            
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        struct Bindings_Albedo_e5a8c819ad3623244a943a45dac4ffa4
        {
            half4 uv0;
        };

        void SG_Albedo_e5a8c819ad3623244a943a45dac4ffa4(float4 Vector4_12A72EFC, UnityTexture2D Texture2D_9644D008, float2 Vector2_E2350C2, float2 Vector2_D0710BCD, Bindings_Albedo_e5a8c819ad3623244a943a45dac4ffa4 IN, out float4 AlbedoTransp_1)
        {
            float4 _Property_ead5a42fe40ddf8890ef8f59627dbf00_Out_0 = Vector4_12A72EFC;
            float _Split_eefb1b94fc79aa81969b28152339aaa5_R_1 = _Property_ead5a42fe40ddf8890ef8f59627dbf00_Out_0[0];
            float _Split_eefb1b94fc79aa81969b28152339aaa5_G_2 = _Property_ead5a42fe40ddf8890ef8f59627dbf00_Out_0[1];
            float _Split_eefb1b94fc79aa81969b28152339aaa5_B_3 = _Property_ead5a42fe40ddf8890ef8f59627dbf00_Out_0[2];
            float _Split_eefb1b94fc79aa81969b28152339aaa5_A_4 = _Property_ead5a42fe40ddf8890ef8f59627dbf00_Out_0[3];
            float4 _Combine_0989ac05ac713585b1970bd9dce2d35a_RGBA_4;
            float3 _Combine_0989ac05ac713585b1970bd9dce2d35a_RGB_5;
            float2 _Combine_0989ac05ac713585b1970bd9dce2d35a_RG_6;
            Unity_Combine_float(_Split_eefb1b94fc79aa81969b28152339aaa5_R_1, _Split_eefb1b94fc79aa81969b28152339aaa5_G_2, _Split_eefb1b94fc79aa81969b28152339aaa5_B_3, 1, _Combine_0989ac05ac713585b1970bd9dce2d35a_RGBA_4, _Combine_0989ac05ac713585b1970bd9dce2d35a_RGB_5, _Combine_0989ac05ac713585b1970bd9dce2d35a_RG_6);
            UnityTexture2D _Property_c6a26ce271d98f84bb13cd7ce0ae398d_Out_0 = Texture2D_9644D008;
            float2 _Property_fe6e35ca6b347f83a931216e0b119ec0_Out_0 = Vector2_E2350C2;
            float2 _Property_422e593a494f798fbe504a4f2b01c59a_Out_0 = Vector2_D0710BCD;
            float2 _TilingAndOffset_7708bc2bff71f48e91e0337bac4a6137_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_fe6e35ca6b347f83a931216e0b119ec0_Out_0, _Property_422e593a494f798fbe504a4f2b01c59a_Out_0, _TilingAndOffset_7708bc2bff71f48e91e0337bac4a6137_Out_3);
            float4 _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c6a26ce271d98f84bb13cd7ce0ae398d_Out_0.tex, _Property_c6a26ce271d98f84bb13cd7ce0ae398d_Out_0.samplerstate, _TilingAndOffset_7708bc2bff71f48e91e0337bac4a6137_Out_3);
            float _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_R_4 = _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0.r;
            float _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_G_5 = _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0.g;
            float _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_B_6 = _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0.b;
            float _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_A_7 = _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0.a;
            float4 _Multiply_2bed8dfc9ac182839f4890b363090fbe_Out_2;
            Unity_Multiply_float(_Combine_0989ac05ac713585b1970bd9dce2d35a_RGBA_4, _SampleTexture2D_6d40c1dec13dc3858a7b269c352627ee_RGBA_0, _Multiply_2bed8dfc9ac182839f4890b363090fbe_Out_2);
            AlbedoTransp_1 = _Multiply_2bed8dfc9ac182839f4890b363090fbe_Out_2;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float4 _Property_0c463843746e288391b8f14568c1b226_Out_0 = _MainColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            UnityTexture2D _Property_e2d0c96d6ea00780805055033bae5838_Out_0 = UnityBuildTexture2DStructNoScale(_MainTexture);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float2 _Property_b1ef9ff04e418d8ca08a9d853ebb74fb_Out_0 = _Tiling;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float2 _Property_476ca1516c65628ba31419a95cbea98c_Out_0 = _Offset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            Bindings_Albedo_e5a8c819ad3623244a943a45dac4ffa4 _Albedo_cf2dc1721f2db789a4f0673fe3b88499;
            _Albedo_cf2dc1721f2db789a4f0673fe3b88499.uv0 = IN.uv0;
            float4 _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1;
            SG_Albedo_e5a8c819ad3623244a943a45dac4ffa4(_Property_0c463843746e288391b8f14568c1b226_Out_0, _Property_e2d0c96d6ea00780805055033bae5838_Out_0, _Property_b1ef9ff04e418d8ca08a9d853ebb74fb_Out_0, _Property_476ca1516c65628ba31419a95cbea98c_Out_0, _Albedo_cf2dc1721f2db789a4f0673fe3b88499, _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
            float _Split_7b58296a546e388389f1dca27ac980fb_R_1 = _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1[0];
            float _Split_7b58296a546e388389f1dca27ac980fb_G_2 = _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1[1];
            float _Split_7b58296a546e388389f1dca27ac980fb_B_3 = _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1[2];
            float _Split_7b58296a546e388389f1dca27ac980fb_A_4 = _Albedo_cf2dc1721f2db789a4f0673fe3b88499_AlbedoTransp_1[3];
            #endif
            surface.Alpha = _Split_7b58296a546e388389f1dca27ac980fb_A_4;
            surface.AlphaClipThreshold = 0.5;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.ObjectSpaceNormal =           input.normalOS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.ObjectSpaceTangent =          input.tangentOS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.ObjectSpacePosition =         input.positionOS;
        #endif


            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7) || defined(KEYWORD_PERMUTATION_8) || defined(KEYWORD_PERMUTATION_9) || defined(KEYWORD_PERMUTATION_10) || defined(KEYWORD_PERMUTATION_11) || defined(KEYWORD_PERMUTATION_12) || defined(KEYWORD_PERMUTATION_13) || defined(KEYWORD_PERMUTATION_14) || defined(KEYWORD_PERMUTATION_15) || defined(KEYWORD_PERMUTATION_16) || defined(KEYWORD_PERMUTATION_17) || defined(KEYWORD_PERMUTATION_18) || defined(KEYWORD_PERMUTATION_19) || defined(KEYWORD_PERMUTATION_20) || defined(KEYWORD_PERMUTATION_21) || defined(KEYWORD_PERMUTATION_22) || defined(KEYWORD_PERMUTATION_23) || defined(KEYWORD_PERMUTATION_24) || defined(KEYWORD_PERMUTATION_25) || defined(KEYWORD_PERMUTATION_26) || defined(KEYWORD_PERMUTATION_27) || defined(KEYWORD_PERMUTATION_28) || defined(KEYWORD_PERMUTATION_29) || defined(KEYWORD_PERMUTATION_30) || defined(KEYWORD_PERMUTATION_31)
        output.uv0 =                         input.texCoord0;
        #endif

        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

            ENDHLSL
        }
    }
    FallBack "Hidden/Shader Graph/FallbackError"
}