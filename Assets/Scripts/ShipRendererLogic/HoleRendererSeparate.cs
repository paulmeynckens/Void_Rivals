using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ShipsLogic.Holes;
using GeneralRendering;
using Mirror;

namespace ShipsRenderer
{
    public class HoleRendererSeparate : MonoBehaviour
    {
        
        private void Awake()
        {
            HoleSpawn holeSpawn=GetComponentInParent<HoleSpawn>();
            holeSpawn.OnHolePlaced += SeparateHoleRenderer;
        }


        void SeparateHoleRenderer(NetworkIdentity networkIdentity, Vector3 targetLocalPosition, Quaternion targetLocalRotation)
        {
            Transform targetParent = LinkToRenderer.shipsRenderersLinks[networkIdentity.transform];
            transform.parent = targetParent;

            transform.localPosition = targetLocalPosition;
            transform.localRotation = targetLocalRotation;
        }
    }
}
