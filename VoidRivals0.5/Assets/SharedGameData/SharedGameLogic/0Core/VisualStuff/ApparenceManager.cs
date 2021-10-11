using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
using System;

namespace Core.VisualStuff
{
    public class ApparenceManager : NetworkBehaviour
    {
        
    }

    [Serializable]
    public struct RendererGroup
    {
        public Material blueMaterial;
        public Material redMaterial;
        public List<Renderer> renderers;

        public void SetMaterial(bool color)
        {
            foreach(Renderer renderer in renderers)
            {
                if (color)
                {
                    renderer.material = blueMaterial;
                }
                else
                {
                    renderer.material = redMaterial;
                }
            }
        }
    }
}
