using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
using System;

namespace Core.Interractables
{
    public class ItemDeposit : Interractable, IChangeQuantity
    {

        

        [SerializeField] protected string itemType = "NO";
        [SerializeField] protected bool infiniteSupply = false;
        [SerializeField] protected short maxQuantity = 1;



        public event Action OnLoad;

        /// <summary>
        /// current quantity, max quantity
        /// </summary>
        public event Action<short, short> OnChangeQuantity=delegate { };

        public short ItemQuantity
        {
            get => itemQuantity;
        }

        [SyncVar(hook = nameof(ClientChangeQuantityVisual))] protected short itemQuantity = 0;

        protected virtual void ClientChangeQuantityVisual(short _old, short _new)
        {
            OnChangeQuantity(_old, _new);
        }


        public override void OnStartServer()
        {
            base.OnStartServer();
            itemQuantity = maxQuantity;
        }




        protected override void ServerUseObjectE(NetworkIdentity requestingPlayer)
        {
            ServerPickupObject(requestingPlayer);
        }




        [Server]
        protected virtual void ServerPickupObject(NetworkIdentity p_requestingPlayer)
        {
            ICanGrabItem characterHands = p_requestingPlayer.GetComponent<ICanGrabItem>();

            if (characterHands.HeldItemType == "NO") //give an item to the player
            {
                if (infiniteSupply)
                {
                    characterHands.ServerGrabItem(itemType);
                }
                else
                {
                    if (itemQuantity > 0)
                    {
                        if (ServerCanGiveItemToPlayer())
                        {
                            characterHands.ServerGrabItem(itemType);
                        }
                        
                        itemQuantity--;

                        if (itemQuantity <= 0)
                        {
                            ServerEmpty();
                        }
                    }
                    else
                    {
                        TargetRefuseAction(p_requestingPlayer.connectionToClient);
                    }

                }
                
            }

        }


        /// <summary>
        /// example use : overriden by ShipGunMagasine  to prevent players to ressuply the gun without picking ammos in the ammo boxes
        /// </summary>
        /// <returns></returns>
        protected virtual bool ServerCanGiveItemToPlayer()
        {
            return true;
        }

        protected override void ServerUseObjectClick(NetworkIdentity requestingPlayer)
        {
            ServerDropObject(requestingPlayer);
        }

        [Server]
        protected virtual void ServerDropObject(NetworkIdentity p_requestingPlayer)
        {
            ICanGrabItem characterHands = p_requestingPlayer.GetComponent<ICanGrabItem>();

            if (characterHands.HeldItemType == itemType) //store player's item in the depositt. 
            {
                if (infiniteSupply)
                {
                    characterHands.ServerDropItem();
                    return;
                }
                if (itemQuantity < maxQuantity)
                {
                    characterHands.ServerDropItem();
                    itemQuantity++;
                    if (itemQuantity == maxQuantity)
                    {
                        ServerSetFull();
                    }
                }
                return;
            }


        }

        [Server]
        public virtual void ServerEmpty()
        {

        }

        [Server]
        protected virtual void ServerSetFull()
        {
            if (OnLoad != null)
            {
                OnLoad();
            }

        }

    }
}





