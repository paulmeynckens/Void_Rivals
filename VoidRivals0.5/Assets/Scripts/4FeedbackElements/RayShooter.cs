using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core;

namespace FeedbackElements
{
    public class RayShooter : MonoBehaviour
    {
        [SerializeField] Transform ray=null;
        [SerializeField] ParticleSystem hitSpot = null;
        [SerializeField] Transform emitter = null;
        [SerializeField] LayerMask layerMask;

        private void Awake()
        {
            INeedInstantFeedback needInstantFeedback = GetComponentInParent<INeedInstantFeedback>();
            needInstantFeedback.OnNeedFeedback += ShootRay;
            hitSpot.transform.parent = null;
            ray.parent = null;
        }

        void ShootRay()
        {
            
            RaycastHit hit;
            if(Physics.Raycast(emitter.position, emitter.forward,out hit, 1000, layerMask))
            {
                hitSpot.transform.position = hit.point;
                hitSpot.Play();


                ray.position = emitter.position;
                ray.rotation = emitter.rotation;
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
