using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
using Core;
using Core.ServerAuthoritativeActions;

namespace CharacterLogic
{
    /*
    public enum CharacterMode : byte
    {
        walking,
        magnetic_boots,
        flying,
    */


    public class CharacterMove : ServerAuthoritativeMovement
    {
        [SerializeField] TwoAxisRotator twoAxisRotator=null;

        
        CharacterMoveMode moveMode;

        CharacterWalk characterWalk;

        CharacterMagneticBoots characterMagneticBoots;

        CharacterFly characterFly;

        CharacterSitMode characterSit;

        public CharacterInput DisplayedInput
        {
            get => displayedInput;
        }
        CharacterInput displayedInput = null;

        float lastTransitionTime = -10;// -10 instead of 0 to make sure the character controller gets parented when spawned

        Transform previousParent = null;
        NetworkIdentity cachedIdentity = null;

        private void Awake()
        {
            

            characterWalk = GetComponent<CharacterWalk>();
            characterMagneticBoots = GetComponent<CharacterMagneticBoots>();
            characterFly = GetComponent<CharacterFly>();
            characterSit = GetComponent<CharacterSitMode>();
            
            characterWalk.TwoAxis = twoAxisRotator;
            characterMagneticBoots.TwoAxis = twoAxisRotator;
            characterFly.TwoAxis = twoAxisRotator;

            moveMode = characterWalk;
        }


        protected override void Update()
        {
            base.Update();
            if (hasAuthority && moveMode != characterSit)
            {
                twoAxisRotator.RotateView();
            }

        }
        protected override void FixedUpdate()
        {
            if (previousParent != transform.parent)
            {
                cachedIdentity = transform.parent.GetComponent<NetworkIdentity>();
                ManageMode(cachedIdentity);
            }
            previousParent = transform.parent;


            if (moveMode == characterSit)
            {                
                transform.localPosition = Vector3.zero;
                transform.localRotation = Quaternion.identity;
                
            }
            base.FixedUpdate();
        }


        #region Client
        protected override InputSnapshot ClientCollectInputs(ushort tick)
        {
            if (InputsBlocker.instance.BlockPlayerInputs())
            {
                return new CharacterInput
                {
                    tick = tick,
                    forwardBackward = 0,
                    rightLeft = 0,
                    jump = false,
                    yRotation = twoAxisRotator.horizontalRotator.localEulerAngles.y,
                    xRotation = twoAxisRotator.pointer.localEulerAngles.x,

                };
            }

            float _forwardBackward = 0;
            if(Input.GetKey(KeyBindings.Pairs[PlayerAction.forward]) && !Input.GetKey(KeyBindings.Pairs[PlayerAction.backward]))
            {
                _forwardBackward = 1;
            }
            if (Input.GetKey(KeyBindings.Pairs[PlayerAction.backward]) && !Input.GetKey(KeyBindings.Pairs[PlayerAction.forward]))
            {
                _forwardBackward = -1;
            }

            float _rightLeft = 0;
            if (Input.GetKey(KeyBindings.Pairs[PlayerAction.right]) && !Input.GetKey(KeyBindings.Pairs[PlayerAction.left]))
            {
                _rightLeft = 1;
            }
            if (Input.GetKey(KeyBindings.Pairs[PlayerAction.left]) && !Input.GetKey(KeyBindings.Pairs[PlayerAction.right]))
            {
                _rightLeft = -1;
            }
            return new CharacterInput
            {
                tick = tick,
                forwardBackward = _forwardBackward,
                rightLeft = _rightLeft,
                jump = Input.GetKey(KeyBindings.Pairs[PlayerAction.jump]),
                yRotation = twoAxisRotator.horizontalRotator.localEulerAngles.y,
                xRotation = twoAxisRotator.pointer.localEulerAngles.x,

            };
        }

        protected override void ClientCompareState(StateSnapshot bufferedState, StateSnapshot newState)
        {
            if(bufferedState is CharacterSnapshot buffer && newState is CharacterSnapshot target)
            {
                
                if (buffer.parentIdentity != target.parentIdentity)
                {
                    if (showDebugMessages)
                    {
                        Debug.Log("parent not matching, switching state");
                    }

                    ManageMode(target.parentIdentity);

                    buffer.localPosition = target.parentIdentity.transform.InverseTransformPoint(buffer.parentIdentity.transform.TransformPoint(buffer.localPosition));
                    buffer.localRotation = Quaternion.Inverse(target.parentIdentity.transform.rotation) * buffer.parentIdentity.transform.rotation * buffer.localRotation;
                    transform.parent = target.parentIdentity.transform;

                    /*
                    switch ((CharacterMode)target.characterMode)
                    {
                        case CharacterMode.flying:
                            transform.parent = null;
                            //buffer.localPosition = BodiesHolder.exteriors[buffer.parentShip].TransformPoint(buffer.localPosition);
                            //buffer.localRotation = BodiesHolder.exteriors[buffer.parentShip].rotation * buffer.localRotation;
                            break;

                        default:
                            
                            break;
                    }
                    */
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
                ManageMode(characterSnapshot.parentIdentity);
                

                
                transform.localPosition = characterSnapshot.localPosition;
                transform.localRotation = characterSnapshot.localRotation;
            }
            
        }
        #endregion

        #region State machine
        private void OnTriggerEnter(Collider other)
        {
            
            
            
            

            if (other.gameObject.TryGetComponent(out CharacterMovementModeSwapper characterMovementModeSwapper))
            {
                if (!EnoughTransitionTimePassed())
                {
                    return;
                }
                ManageMode(characterMovementModeSwapper.target);
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

        public void ManageMode(NetworkIdentity parentIdentity)
        {
            moveMode.Deactivate();
            
            if (parentIdentity == null)
            {
                moveMode = characterFly;
                return;
            }
            else
            {
                switch (parentIdentity.tag)
                {
                    case "Ship Interior":
                        moveMode = characterWalk;
                        break;

                    case "Ship Hull":
                        moveMode = characterMagneticBoots;
                        break;

                    case "Seat":
                        moveMode = characterSit;
                        break;

                    default:
                        Debug.LogError("no matching Tag : " + parentIdentity.tag);
                        break;
                }
            }
            moveMode.Activate();

            transform.parent = parentIdentity.transform;
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
                parentIdentity = cachedIdentity,
                localPosition = transform.localPosition,
                localRotation = transform.localRotation
            };
        }
        NetworkIdentity FindParentNetId()
        {
            /*
            NetworkIdentity foundIdentity = null;

            if (previousParent != transform.parent)
            {
                foundIdentity = transform.parent.GetComponent<NetworkIdentity>();
            }
            previousParent = transform.parent;

            
            return foundIdentity;
            */

            return transform.parent.GetComponent<NetworkIdentity>();
        }
        #endregion
    }
}
