using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;
using CharacterLogic;
using Core.Interractables;
using RotaryHeart.Lib.SerializableDictionary;
using Mirror;
using GeneralRendering;

namespace CharacterRenderer
{
    [DefaultExecutionOrder(+10)]
    public class CharacterInterpolate : MonoBehaviour
    {
        public static Transform localPlayerShip = null;

        [SerializeField] Transform horizontalRotator = null;
        [SerializeField] Transform rigg = null;

        [SerializeField] Transform pointer = null;
        [SerializeField] Transform hands = null;
       



        NetworkIdentity networkIdentity;
        CharacterMove characterMove;

        
 

        float lastInterpolationTime = 0;

        

        Transform lastParent = null;
        Transform nextParent = null;

        Vector3 lastBodyLocalPosition = Vector3.zero;
        Vector3 nextBodyLocalPosition = Vector3.zero;

        Quaternion lastBodyLocalRotation = Quaternion.identity;
        Quaternion nextBodyLocalRotation = Quaternion.identity;

        Quaternion lastRotatorLocalRotation = Quaternion.identity;
        Quaternion nextRotatorLocalRotation = Quaternion.identity;

        Quaternion lastPointerLocalRotation = Quaternion.identity;
        Quaternion nextPointerLocalRotation = Quaternion.identity;

        
        private void Awake()
        {
            networkIdentity = GetComponentInParent<NetworkIdentity>();

            characterMove = GetComponentInParent<CharacterMove>();
        }


        private void FixedUpdate()
        {
            

            if (networkIdentity == null)
            {
                Destroy(this.gameObject);
            }

            UpdateInterpolationData();

        }

        // Update is called once per frame
        void Update()
        {


            if (characterMove == null)
            {
                Destroy(this.gameObject);
            }

            float interpolationIncrement = (Time.time - lastInterpolationTime) / Time.fixedDeltaTime;

            InterpolateBodyPosition(interpolationIncrement);
            InterPolateBodyRotation(interpolationIncrement);


            if (ShouldInterpolateInternalRotations())
            {
                InterpolateInternalRotations(interpolationIncrement);
            }
            else
            {
                rigg.localRotation = horizontalRotator.localRotation;
                hands.localRotation = pointer.localRotation;
            }

        }
        



        void UpdateInterpolationData()
        {
            lastInterpolationTime = Time.time;

            if (networkIdentity.transform.parent == null)
            {
                transform.parent = null;
            }
            else
            {
                transform.parent = LinkToRenderer.shipsRenderersLinks[networkIdentity.transform.parent];
            }

            transform.localScale = Vector3.one;

            lastParent = nextParent;
            nextParent = transform.parent;

            lastBodyLocalPosition = nextBodyLocalPosition;
            nextBodyLocalPosition = networkIdentity.transform.localPosition ;

            lastBodyLocalRotation = nextBodyLocalRotation;
            nextBodyLocalRotation = networkIdentity.transform.localRotation;

            if (ShouldInterpolateInternalRotations())
            {
                lastRotatorLocalRotation = nextRotatorLocalRotation;
                nextRotatorLocalRotation = horizontalRotator.localRotation;

                lastPointerLocalRotation = nextPointerLocalRotation;
                nextPointerLocalRotation = pointer.localRotation;
            }
        }

    

        bool ShouldInterpolateInternalRotations()
        {
            return characterMove.CurrentCharacterMode != CharacterMode.walking && networkIdentity.hasAuthority;
        }

        void InterpolateBodyPosition(float interpolationIncrement)
        {
            if (lastParent != nextParent)
            {
                if (lastParent == null)
                {
                    lastBodyLocalPosition = nextParent.InverseTransformPoint(lastBodyLocalPosition);                   
                }
                else if (nextParent == null)
                {
                    lastBodyLocalPosition = lastParent.TransformPoint(lastBodyLocalPosition);
                }
                else
                {
                    lastBodyLocalPosition = nextParent.InverseTransformPoint(transform.parent.TransformPoint(lastBodyLocalPosition));
                }
                
            }

            transform.localPosition = Vector3.Lerp(lastBodyLocalPosition, nextBodyLocalPosition, interpolationIncrement);
        }

        void InterPolateBodyRotation(float interpolationIncrement)
        {
            if (lastParent != nextParent)
            {
                if (lastParent == null)
                {
                    lastBodyLocalRotation = lastBodyLocalRotation * Quaternion.Inverse(nextParent.rotation);
                }
                else if (nextParent == null)
                {
                    lastBodyLocalRotation = lastBodyLocalRotation * nextParent.rotation;
                }
                else
                {
                    lastBodyLocalRotation = lastBodyLocalRotation * lastParent.rotation * Quaternion.Inverse(nextParent.rotation);
                }

            }

            transform.localRotation = Quaternion.Lerp(lastBodyLocalRotation, nextBodyLocalRotation, interpolationIncrement);
        }

        void InterpolateInternalRotations(float interpolationIncrement)
        {

            rigg.localRotation = Quaternion.Lerp(lastRotatorLocalRotation, nextRotatorLocalRotation, interpolationIncrement);
            hands.localRotation = Quaternion.Lerp(lastPointerLocalRotation, nextPointerLocalRotation, interpolationIncrement);

        }


        private void OnDestroy()
        {
            localPlayerShip = null;
        }
    }

}
