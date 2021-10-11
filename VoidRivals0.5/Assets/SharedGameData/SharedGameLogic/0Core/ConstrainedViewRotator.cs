using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;


namespace Core
{
    public class ConstrainedViewRotator : MonoBehaviour
    {
        [SerializeField] TwoAxisRotator twoAxisRotator=null;
        NetworkIdentity networkIdentity;

        private void Awake()
        {
            networkIdentity = GetComponent<NetworkIdentity>();
        }
        // Update is called once per frame
        void Update()
        {
            if (networkIdentity.isClient && networkIdentity.hasAuthority)
            {
                if (Input.GetKey(KeyBindings.Pairs[Actions.aim]))
                {
                    twoAxisRotator.RotateView();
                }
                else
                {
                    twoAxisRotator.GentlySnapForward();
                }

            }

        }
    }
}
