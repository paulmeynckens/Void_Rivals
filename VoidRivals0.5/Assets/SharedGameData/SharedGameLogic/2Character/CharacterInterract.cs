using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
using Core.Interractables;
using Core;

namespace CharacterLogic
{
    public class CharacterInterract : NetworkBehaviour, ICanSit, ICanDie
    {
        [SerializeField] private float m_selectionRange = 2f;

        [SerializeField] private LayerMask m_SelectableItemsLayer = 0;

        [SerializeField] Transform m_pointerTransform = null; //to know where the player is looking

        Interractor currentTarget = null;
        Interractor previousTarget = null;
        bool alive = true;
       

        private void FixedUpdate()
        {
            if (alive && (hasAuthority || isServer))
            {
                currentTarget = FindActivator();

                if (currentTarget != null)
                {
                    currentTarget.ClientActivate();
                }

                if (previousTarget != null && previousTarget != currentTarget)
                {
                    previousTarget.ClientDeactivate();
                }
                previousTarget = currentTarget;


                if (hasAuthority)
                {
                    if (Input.GetKey(KeyBindings.Pairs[Actions.interact]))
                    {
                        if (currentTarget != null)
                        {
                            currentTarget.ClientConfirm();
                        }

                        CmdTryInteract();
                    }
                }

            }
        }

        #region Both sides
        Interractor FindActivator()
        {
            Ray ray = new Ray(m_pointerTransform.position, m_pointerTransform.forward);
            RaycastHit raycastHit;

            Interractor foundActivator = null;

            if (Physics.Raycast(ray, out raycastHit, m_selectionRange, m_SelectableItemsLayer, QueryTriggerInteraction.Collide) == true)
            {
                foundActivator = raycastHit.collider.GetComponent<Interractor>();
            }
            return foundActivator;
        }


        #endregion


        #region Commands

        [Command(channel = Channels.Unreliable)]
        void CmdTryInteract()
        {
            if (enabled)
            {

                if (currentTarget != null)
                {
                    currentTarget.ServerInterract(netIdentity);
                }


            }

        }

        void ICanSit.SitHere(Transform p_rightHandGrip, Transform p_leftHandGrip, Transform p_newheadPointer, Transform p_sittingPosition, bool p_needSitting)
        {
            enabled = false;
        }

        void ICanSit.GetUp()
        {
            enabled = true;
        }

        void ICanDie.Kill()
        {
            alive = false;
        }

        #endregion

    }
}

