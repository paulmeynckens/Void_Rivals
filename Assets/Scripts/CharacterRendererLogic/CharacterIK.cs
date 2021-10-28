using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
using RotaryHeart.Lib.SerializableDictionary;
using CharacterLogic;

namespace CharacterRenderer
{
    [Serializable]
    public struct IKData
    {
        public Transform rightHandObj;
        public Transform rightElbowObj;
        public Transform leftHandObj;
        public Transform leftElbowObj;
    }
    [Serializable]
    public class HoldableItemsDictionnary : SerializableDictionaryBase<string, HoldableItem> { }

    public class CharacterIK : MonoBehaviour
    {
        [SerializeField] Transform eyes = null;
        [SerializeField] Transform lookTarget = null;
        [SerializeField] Transform hands = null;
        [SerializeField] HoldableItemsDictionnary holdableItems = null;

        CharacterHands characterHands;
        CharacterSit characterSit;
        NetworkIdentity networkIdentity;


        Animator animator;
        Transform seatViewDirection = null;
        Transform rightHandObj = null;
        Transform rightElbowObj = null;
        Transform leftHandObj = null;
        Transform leftElbowObj = null;

        private void Awake()
        {
            networkIdentity = GetComponentInParent<NetworkIdentity>();
            animator = GetComponent<Animator>();
            characterHands = GetComponentInParent<CharacterHands>();
            characterSit = GetComponentInParent<CharacterSit>();
            characterSit.OnClientGetUp += GetUp;
            characterSit.OnClientSit += Sit;
            characterHands.OnClientChangeItem += GrabItem;
        }

        // Start is called before the first frame update
        void Start()
        {

            if (networkIdentity.hasAuthority)
            {
                CameraManager.instance.SetEyes(eyes);
            }
        }

        // Update is called once per frame
        void Update()
        {
            if (seatViewDirection != null)
            {

                eyes.rotation = seatViewDirection.rotation;

            }
            else
            {
                eyes.rotation = hands.rotation;
            }
        }


        private void OnAnimatorIK(int layerIndex)
        {
            animator.SetLookAtWeight(1);
            animator.SetLookAtPosition(lookTarget.position);


            if (rightHandObj != null)
            {
                animator.SetIKPositionWeight(AvatarIKGoal.RightHand, 1);
                animator.SetIKRotationWeight(AvatarIKGoal.RightHand, 1);
                animator.SetIKPosition(AvatarIKGoal.RightHand, rightHandObj.position);
                animator.SetIKRotation(AvatarIKGoal.RightHand, rightHandObj.rotation);
            }

            if (rightElbowObj != null)
            {
                animator.SetIKHintPosition(AvatarIKHint.RightElbow, rightElbowObj.position);
                animator.SetIKHintPositionWeight(AvatarIKHint.RightElbow, 1);
            }


            if (leftHandObj != null)
            {
                animator.SetIKPositionWeight(AvatarIKGoal.LeftHand, 1);
                animator.SetIKRotationWeight(AvatarIKGoal.LeftHand, 1);
                animator.SetIKPosition(AvatarIKGoal.LeftHand, leftHandObj.position);
                animator.SetIKRotation(AvatarIKGoal.LeftHand, leftHandObj.rotation);
            }

            if (leftElbowObj != null)
            {
                animator.SetIKHintPosition(AvatarIKHint.LeftElbow, leftElbowObj.position);
                animator.SetIKHintPositionWeight(AvatarIKHint.LeftElbow, 1);
            }


        }

        void GetUp()
        {
            animator.SetBool("Sit", false);
            seatViewDirection = null;
            GrabItem(characterHands.HeldItemType);

        }
        void Sit()
        {
            foreach (KeyValuePair<string, HoldableItem> holdableItem in holdableItems)
            {
                holdableItem.Value.gameObject.SetActive(false);
            }
            SeatPostureData seatPostureData = SeatPostureDataHolder.seatIKs[characterSit.CurrentSeat];

            animator.SetBool("Sit", seatPostureData.needsSitting);
            seatViewDirection = seatPostureData.viewDirection;
            GrabHandles(seatPostureData.iKData);


        }
        void GrabItem(string item)
        {
            foreach (KeyValuePair<string, HoldableItem> holdableItem in holdableItems)
            {
                holdableItem.Value.gameObject.SetActive(false);
            }
            holdableItems[item].gameObject.SetActive(true);
            GrabHandles(holdableItems[item].iKData);
        }

        void GrabHandles(IKData iKData)
        {
            rightHandObj = iKData.rightHandObj;
            rightElbowObj = iKData.rightElbowObj;

            leftHandObj = iKData.leftHandObj;
            leftElbowObj = iKData.leftElbowObj;
        }

    }
}
