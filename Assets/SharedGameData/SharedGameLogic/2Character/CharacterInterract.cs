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

        Interractable currentTarget = null;
        Interractable previousTarget = null;
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
                    if (Input.GetKey(KeyBindings.Pairs[PlayerAction.interact]))
                    {
                        if (currentTarget != null)
                        {
                            currentTarget.ClientConfirm();
                        }

                        CmdTryInteractE();
                    }
                    if (Input.GetKey(KeyBindings.Pairs[PlayerAction.shoot]))
                    {
                        if (currentTarget != null)
                        {
                            currentTarget.ClientConfirm();
                        }

                        CmdTryInteractClick();
                    }
                }

            }
        }

        #region Both sides
        Interractable FindActivator()
        {
            Ray ray = new Ray(m_pointerTransform.position, m_pointerTransform.forward);
            RaycastHit raycastHit;

            Interractable foundActivator = null;

            if (Physics.Raycast(ray, out raycastHit, m_selectionRange, m_SelectableItemsLayer, QueryTriggerInteraction.Collide) == true)
            {
                foundActivator = raycastHit.collider.GetComponent<Interractable>();
            }
            return foundActivator;
        }


        #endregion


        #region Commands

        [Command(channel = Channels.Unreliable)]
        void CmdTryInteractE()
        {
            if (enabled)
            {

                if (currentTarget != null)
                {
                    currentTarget.ServerTryUseObjectE(netIdentity);
                }


            }

        }

        [Command(channel = Channels.Unreliable)]
        void CmdTryInteractClick()
        {
            if (enabled)
            {

                if (currentTarget != null)
                {
                    currentTarget.ServerTryUseObjectClick(netIdentity);
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

