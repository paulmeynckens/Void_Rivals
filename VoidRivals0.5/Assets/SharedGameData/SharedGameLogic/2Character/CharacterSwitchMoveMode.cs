using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using Mirror;
using Core;

namespace CharacterLogic
{
    
    public class CharacterSwitchMoveMode : NetworkBehaviour
    {
        public CharacterMode CurrentCharacterMode
        {
            get => currentCharacterMode;
        }
        [SyncVar(hook = nameof(SwitchToMode))]private CharacterMode currentCharacterMode = CharacterMode.walking;//initial movement mode is walking

        public CharacterMoveMode CharacterMove
        {
            get => characterMove;
        }
        CharacterMoveMode characterMove;

        CharacterWalk characterWalk;

        CharacterMagneticBoots characterMagneticBoots;

        CharacterFly characterFly;
        

        private void Awake()
        {

            SwitchToMode(CharacterMode.walking, CharacterMode.walking);

            characterWalk = GetComponent<CharacterWalk>();
            

            characterMagneticBoots = GetComponent<CharacterMagneticBoots>();
            

            characterFly = GetComponent<CharacterFly>();
            

        }

        public void SetTwoAxis(TwoAxisRotator twoAxisRotator)
        {
            characterWalk.TwoAxis = twoAxisRotator;
            characterMagneticBoots.TwoAxis = twoAxisRotator;
            characterFly.TwoAxis = twoAxisRotator;
        }



        private void OnTriggerEnter(Collider other)
        {
            switch (other.gameObject.tag)
            {
                case "Airlock Entry":
                    SwitchToWalkMode(other.transform);
                    break;

                    
                    
                case "Airlock Exit":
                    SwitchToFlyMode(other.transform);//to remove when implementing magnetic boots
                    break;

                case "Exit To Hull":
                    SwitchFromWalkToMagneticMode(other.transform);
                    break;                    
 

                case "Ship Hull":
                    SwitchFromFlyToMagneticMode(other.transform);
                    break;

                default:

                    break;
            }
        }

        
        private void OnTriggerExit(Collider other)
        {
            if(other.gameObject.CompareTag("Ship Hull"))
            {
                SwitchToFlyMode(other.transform);
            }

        }
        

        void SwitchToMode(CharacterMode p_old, CharacterMode p_new)
        {
            if (isServer)
            {
                currentCharacterMode = p_new;
            }

            characterMove.Deactivate();
            
            switch (p_new)
            {
                case CharacterMode.flying:
                    characterMove= characterFly;
                    break;
                case CharacterMode.magnetic_boots:
                    characterMove = characterMagneticBoots;
                    break;
                case CharacterMode.walking:
                    characterMove = characterWalk;
                    break;

            }

            characterMove.Activate();
        }

        void SwitchToWalkMode(Transform entry)
        {
            Vector3 newLocalPosition = entry.InverseTransformPoint(transform.position);
            Quaternion newLocalRotation = transform.rotation * Quaternion.Inverse(entry.rotation);
            newLocalRotation = Quaternion.Euler(0, newLocalRotation.eulerAngles.y, 0);

            transform.parent = entry.GetComponent<Replicator>().target;
            transform.localPosition = newLocalPosition;
            transform.localRotation = newLocalRotation;

            SwitchToMode(CharacterMode.walking,CharacterMode.walking);
        }
        

        void SwitchFromFlyToMagneticMode(Transform shipHull)
        {
            transform.parent = shipHull;

            SwitchToMode(CharacterMode.flying,CharacterMode.magnetic_boots);

        }
        void SwitchFromWalkToMagneticMode(Transform toShipHull)
        {
            Vector3 previousLocalPosition = transform.localPosition;
            Quaternion previousLocalRotation = transform.localRotation;

            Transform target = toShipHull.GetComponent<Replicator>().target;            

            transform.parent = target;
            transform.localPosition = previousLocalPosition;
            transform.localRotation = previousLocalRotation;

            SwitchToMode(CharacterMode.walking,CharacterMode.magnetic_boots);

        }

        void SwitchToFlyMode(Transform exit)
        {
            Vector3 addedPosition = transform.localPosition;
            Quaternion addedRotation = transform.localRotation;

            transform.parent = null;
            Transform target = exit.GetComponent<Replicator>().target;
            transform.position = target.TransformPoint(addedPosition);
            transform.rotation = target.rotation * addedRotation;


            SwitchToMode(CharacterMode.walking,CharacterMode.flying);

        }



    }
}
