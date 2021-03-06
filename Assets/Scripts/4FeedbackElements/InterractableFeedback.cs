using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core.Interractables;

namespace FeedbackElements
{
    public class InterractableFeedback : MonoBehaviour
    {
        [SerializeField] Interractable interractable=null;

        [SerializeField] Material defaultMaterial;
        [SerializeField] Material activatedMaterial = null;
        [SerializeField] Material confirmMaterial = null;
        [SerializeField] Material refuseMaterial = null;

        [SerializeField] GameObject helpTip = null;

        Renderer ownRenderer;



        private void Awake()
        {

            ownRenderer = GetComponent<Renderer>();

            defaultMaterial = ownRenderer.material;


            if (activatedMaterial == null)
            {
                activatedMaterial = Resources.Load("Activated") as Material;
            }

            if (confirmMaterial == null)
            {
                confirmMaterial = Resources.Load("Confirm") as Material;
            }

            if (refuseMaterial == null)
            {
                refuseMaterial = Resources.Load("Refuse") as Material;
            }

            interractable.OnClientActivated += ClientActivate;
            interractable.OnClientConfirm += ClientConfirm;
            interractable.OnClientDeactivate += ClientDeactivate;
            interractable.OnClientRefuse += ClientRefuseAction;

            if (helpTip != null)
            {
                helpTip.SetActive(false);
            }
        }



        protected virtual void ClientActivate()
        {
            ownRenderer.material = activatedMaterial;
            if (helpTip != null)
            {
                helpTip.SetActive(true);
            }
        }

        protected virtual void ClientConfirm()
        {
            ownRenderer.material = confirmMaterial;
        }

        protected virtual void ClientDeactivate()
        {
            ownRenderer.material = defaultMaterial;
            if (helpTip != null)
            {
                helpTip.SetActive(false);
            }
        }

        protected virtual void ClientRefuseAction(byte reason)
        {
            ownRenderer.material = refuseMaterial;
        }
    }
}
