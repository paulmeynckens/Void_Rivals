Shader "Mask"
{
    Properties
    {

        [Header(Stencil Masking)]
        _StencilRef("_StencilRef", Float) = 0
        [Enum(UnityEngine.Rendering.CompareFunction)]_StencilComp("_StencilComp (default = Disable)", Float) = 0 //0 = disable
        [Enum(UnityEngine.Rendering.StencilOp)]_StencilOp("_StencilOp (default = Disable)", Float) = 0 //0 = disable
    }
    SubShader
    {

    Tags
		{
			"RenderPipeline" = "UniversalPipeline"
			"RenderType" = "Transparent"
			"Queue" = "Geometry"
		}
         // The rest of the code that defines the SubShader goes here.
             ColorMask 0
		     ZWrite Off
             Stencil
            {
                Ref[_StencilRef]
                Comp[_StencilComp]
                Pass[_StencilOp]
            } 

        Pass
        {    

        }
    }
}
