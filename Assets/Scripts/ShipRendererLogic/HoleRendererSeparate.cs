using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ShipsLogic.Holes;
using GeneralRendering;

namespace ShipsRenderer
{
    public class HoleRendererSeparate : MonoBehaviour
    {
        
        private void Awake()
        {
            HoleSpawn holeSpawn=GetComponentInParent<HoleSpawn>();
            holeSpawn.OnHolePlaced += SeparateHoleRenderer;
        }


        void SeparateHoleRenderer(Transform targetCollider, Vector3 targetLocalPosition, Quaternion targetLocalRotation)
        {
            Transform targetParent = LinkToRenderer.shipsRenderersLinks[targetCollider];
            transform.parent = targetParent;

            transform.localPosition = targetLocalPosition;
            transform.localRotation = targetLocalRotation;
        }
    }
}
