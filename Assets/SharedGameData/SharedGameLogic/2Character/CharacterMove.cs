using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
using Core;
using Core.ServerAuthoritativeActions;

namespace CharacterLogic
{
    public enum CharacterMode : byte
    {
        walking,
        magnetic_boots,
        flying,
    }
    public class CharacterMove : ServerAuthoritativeMovement
    {
        [SerializeField] TwoAxisRotator twoAxisRotator=null;

        public CharacterMode CurrentCharacterMode
        {
            get => currentCharacterMode;
        }
        CharacterMode currentCharacterMode = CharacterMode.walking;//initial movement mode is walking

        CharacterMoveMode moveMode;

        CharacterWalk characterWalk;

        CharacterMagneticBoots characterMagneticBoots;

        CharacterFly characterFly;

        public CharacterInput DisplayedInput
        {
            get => displayedInput;
        }
        CharacterInput displayedInput = null;

        float lastTransitionTime = -10;// -10 instead of 0 to make sure the character controller gets parented when spawned

        NetworkIdentity cachedShipIdentity = null;


        private void Awake()
        {
            

            characterWalk = GetComponent<CharacterWalk>();
            characterMagneticBoots = GetComponent<CharacterMagneticBoots>();
            characterFly = GetComponent<CharacterFly>();

            
            characterWalk.TwoAxis = twoAxisRotator;
            characterMagneticBoots.TwoAxis = twoAxisRotator;
            characterFly.TwoAxis = twoAxisRotator;

            moveMode = characterWalk;
        }


        protected override void Update()
        {
            base.Update();
            if (hasAuthority)
            {
                twoAxisRotator.RotateView();
            }

        }



        #region Client
        protected override InputSnapshot ClientCollectInputs(ushort tick)
        {
            float _forwardBackward = 0;
            if(Input.GetKey(KeyBindings.Pairs[Actions.forward]) && !Input.GetKey(KeyBindings.Pairs[Actions.backward]))
            {
                _forwardBackward = 1;
            }
            if (Input.GetKey(KeyBindings.Pairs[Actions.backward]) && !Input.GetKey(KeyBindings.Pairs[Actions.forward]))
            {
                _forwardBackward = -1;
            }

            float _rightLeft = 0;
            if (Input.GetKey(KeyBindings.Pairs[Actions.right]) && !Input.GetKey(KeyBindings.Pairs[Actions.left]))
            {
                _rightLeft = 1;
            }
            if (Input.GetKey(KeyBindings.Pairs[Actions.left]) && !Input.GetKey(KeyBindings.Pairs[Actions.right]))
            {
                _rightLeft = -1;
            }
            return new CharacterInput
            {
                tick = tick,
                forwardBackward = _forwardBackward,
                rightLeft = _rightLeft,
                jump = Input.GetKey(KeyBindings.Pairs[Actions.jump]),
                yRotation = twoAxisRotator.horizontalRotator.localEulerAngles.y,
                xRotation = twoAxisRotator.pointer.localEulerAngles.x,

            };
        }

        protected override void ClientCorrectState(StateSnapshot bufferedState, StateSnapshot newState)
        {
            if(bufferedState is CharacterSnapshot buffer && newState is CharacterSnapshot target)
            {
                if (buffer.characterMode != target.characterMode)
                {
                    SwitchToMode((CharacterMode)target.characterMode);
                }
                if (buffer.parentShip != target.parentShip)
                {
                    if (showDebugMessages)
                    {
                        Debug.Log("parent not matching");
                    }
                    switch ((CharacterMode)target.characterMode)
                    {
                        case CharacterMode.flying:
                            transform.parent = null;
                            buffer.localPosition = BodiesHolder.exteriors[buffer.parentShip].TransformPoint(buffer.localPosition);
                            buffer.localRotation = BodiesHolder.exteriors[buffer.parentShip].rotation * buffer.localRotation;
                            break;

                        default:
                            buffer.localPosition = target.parentShip.transform.InverseTransformPoint(buffer.parentShip.transform.TransformPoint(buffer.localPosition));
                            buffer.localRotation = Quaternion.Inverse(target.parentShip.transform.rotation) * buffer.parentShip.transform.rotation * buffer.localRotation;
                            transform.parent= target.parentShip.transform;
                            break;
                    }
                }

                Vector3 positionDelta = target.localPosition-buffer.localPosition;
                Quaternion rotationDelta =target.localRotation*Quaternion.Inverse(buffer.localRotation) ;

                transform.localPosition += positionDelta;
                transform.localRotation = transform.localRotation*rotationDelta;

            }
            else
            {
                Debug.LogError("character state not deserialised properly");
            }
        }
        protected override void ClientForceState(StateSnapshot newState)
        {
            if(newState is CharacterSnapshot characterSnapshot)
            {
                SwitchToMode((CharacterMode)characterSnapshot.characterMode);
                switch ((CharacterMode)characterSnapshot.characterMode)
                {
                    case CharacterMode.flying:
                        transform.parent = null;
                        
                        break;

                    default:
                        
                        transform.parent = characterSnapshot.parentShip.transform;
                        break;
                }

                
                transform.localPosition = characterSnapshot.localPosition;
                transform.localRotation = characterSnapshot.localRotation;
            }
            
        }
        #endregion

        #region State machine
        private void OnTriggerEnter(Collider other)
        {
            if (!EnoughTransitionTimePassed())
            {
                return;
            }
            switch (other.gameObject.tag)
            {
                case "Airlock Entry":
                    Debug.Log("enter ship");
                    SwitchFromMagneticToWalkMode();
                    break;


                case "Exit To Hull":
                    SwitchFromWalkToMagneticMode();
                    break;


                case "Ship Hull":
                    SwitchFromFlyToMagneticMode(other.transform);
                    break;

                default:

                    break;
            }
        }

        bool EnoughTransitionTimePassed()
        {
            if (Time.time - lastTransitionTime > 2)
            {
                lastTransitionTime = Time.deltaTime;
                return true;
            }
            return false;

        }




        void SwitchToMode(CharacterMode p_new)
        {
            currentCharacterMode = p_new;

            moveMode.Deactivate();

            switch (p_new)
            {
                case CharacterMode.flying:
                    moveMode = characterFly;
                    break;
                case CharacterMode.magnetic_boots:
                    moveMode = characterMagneticBoots;
                    break;
                case CharacterMode.walking:
                    moveMode = characterWalk;
                    break;

            }

            moveMode.Activate();
        }

        void SwitchFromMagneticToWalkMode()
        {  
            transform.localRotation = Quaternion.Euler(0, transform.localRotation.eulerAngles.y, 0);

            SwitchToMode(CharacterMode.walking);
        }


        void SwitchFromFlyToMagneticMode(Transform externaCollider)
        {
            
            Vector3 previousLocalPosition = externaCollider.InverseTransformPoint(transform.position);
            Quaternion previousLocalRotation = Quaternion.Inverse(externaCollider.rotation)*transform.rotation;

            transform.parent = BodiesHolder.interiors[externaCollider];
            transform.localPosition = previousLocalPosition;
            transform.localRotation = previousLocalRotation;
            SwitchToMode(CharacterMode.magnetic_boots);

        }
        void SwitchFromWalkToMagneticMode()
        {
            SwitchToMode(CharacterMode.magnetic_boots);
        }

        void SwitchFromMagneticToFlyMode()
        {
            transform.parent = null;
            
            SwitchToMode(CharacterMode.flying);

        }
        #endregion

        #region Both sides


        protected override void UseInput(InputSnapshot input)
        {
            if(input is CharacterInput characterInput)
            {
                displayedInput = characterInput;
                if (!hasAuthority)
                {
                    twoAxisRotator.horizontalRotator.localRotation = Quaternion.Euler(0, characterInput.yRotation, 0);
                    twoAxisRotator.pointer.localRotation = Quaternion.Euler(characterInput.xRotation, 0, 0);
                }
                
                moveMode.ModeUseInput(characterInput);
            }
            else
            {
                Debug.LogError("input not deserialised properly");
            }
            
        }
        protected override void ApplyExternalForces()
        {
            base.ApplyExternalForces();
            moveMode.ModeApplyExternalForces();
        }
        protected override StateSnapshot GenerateState(ushort tick)
        {
            return new CharacterSnapshot
            {
                tick = tick,
                characterMode = (byte)currentCharacterMode,
                parentShip = FindParentShip(),
                localPosition = transform.localPosition,
                localRotation = transform.localRotation
            };
        }
        NetworkIdentity FindParentShip()
        {

            if(moveMode is CharacterFly)
            {
                cachedShipIdentity=null;
            }
            else
            {
                if (cachedShipIdentity == null || cachedShipIdentity.transform != transform.parent)
                {
                    cachedShipIdentity = transform.parent.GetComponent<NetworkIdentity>();
                }
                
            }
            return cachedShipIdentity;
        }
        #endregion
    }
}
