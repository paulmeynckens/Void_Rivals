using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core;
using Core.ServerAuthoritativeActions;

namespace FeedbackElements
{
    public class PistolRay : MonoBehaviour
    {
        [SerializeField] ServerAuthoritativeGun needFeedback = null;

        [SerializeField] Transform ray=null;
        [SerializeField] ParticleSystem hitSpot = null;

        [SerializeField] Transform emitterPhysicalParent = null;
        [SerializeField] Transform physicalEmitter = null;
        [SerializeField] Transform emitterRendererParent = null;
        [SerializeField] Transform emitter = null;


        [SerializeField] LayerMask layerMask;

        private void Awake()
        {
            needFeedback.OnNeedFeedback += DisplayRay;
        }

        void DisplayRay()
        {

            RaycastHit hit;

            if(Physics.Raycast(physicalEmitter.transform.position, physicalEmitter.transform.forward,out hit, 1000, layerMask))
            {
                
                hitSpot.transform.parent = emitterRendererParent.parent;
                hitSpot.transform.localPosition = emitterPhysicalParent.parent.InverseTransformPoint(hit.point);
                hitSpot.Play();


                ray.parent = emitterRendererParent.parent;
                ray.position = emitter.position;
                ray.LookAt(hitSpot.transform.position,emitter.up);
                ray.localScale = new Vector3 { x = 1, y = 1, z = Vector3.Distance(emitter.position, hit.point) };
                ray.gameObject.SetActive(true);
                StartCoroutine(CullRay());
            }
            

        }

        IEnumerator CullRay()
        {
            yield return new WaitForSeconds(0.1f);
            ray.gameObject.SetActive(false);

        }

        private void OnDestroy()
        {
            Destroy(ray.gameObject);
            Destroy(hitSpot.gameObject);
        }
    }
}
