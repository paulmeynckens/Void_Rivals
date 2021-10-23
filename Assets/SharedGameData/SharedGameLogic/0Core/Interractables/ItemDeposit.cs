using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
using System;

namespace Core.Interractables
{
    public class ItemDeposit : Interractable, IChangeQuantity
    {

        //[SerializeField] protected ItemDepotMode itemDepotMode = ItemDepotMode.giver;

        [SerializeField] protected string givenItemType = null;
        [SerializeField] protected string requestedItemType = "NO";
        [SerializeField] bool infiniteSupply = false;
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




        protected override void ServerUseObject(NetworkIdentity requestingPlayer)
        {
            ServerPickupOrDropObject(requestingPlayer);
        }


        [Server]
        void ServerPickupOrDropObject(NetworkIdentity p_requestingPlayer)
        {
            ICanGrabItem characterHands = p_requestingPlayer.GetComponent<ICanGrabItem>();

            if (characterHands.HeldItemType == requestedItemType) //give an item to the player
            {
                if (infiniteSupply)
                {
                    characterHands.ServerGrabItem(givenItemType);
                }
                else
                {
                    if (itemQuantity > 0)
                    {
                        characterHands.ServerGrabItem(givenItemType);
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
                return;
            }

            if (characterHands.HeldItemType == givenItemType && givenItemType != " ") //store player's item in the depositt. 
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
                    OnChangeQuantity?.Invoke(itemQuantity, maxQuantity);

                }
                return;
            }

            if (characterHands.HeldItemType == requestedItemType && requestedItemType != " ") //fill the deposit. 
            {
                characterHands.ServerDropItem();
                ServerFill();
                return;
            }



        }

        [Server]
        public virtual void ServerEmpty()
        {

        }

        [Server]
        protected virtual void ServerFill()
        {
            if (OnLoad != null)
            {
                OnLoad();
            }

        }

    }
}





