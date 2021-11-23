using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
using System;

namespace Core
{
    public class Health : NetworkBehaviour
    {
        public short MaxHealth
        {
            get => maxHealth;
        }
        protected short maxHealth;

        protected ICanDie[] aliveOrDeads;


        public event Action<short, short> OnChangeHealthQuantity;

        public event Action OnServerDie = delegate { };
        public event Action OnClientDie = delegate { };

        #region SynVars +hooks

        [SerializeField][SyncVar(hook = nameof(ClientUpdateHealthVisual))] protected short health = 100;
        void ClientUpdateHealthVisual(short _old, short _new)
        {
            OnChangeHealthQuantity?.Invoke(_old, _new);
        }
        public short CurrentHealth
        {
            get => health;
        }
        
        #endregion

        protected virtual void Awake()
        {
            aliveOrDeads = GetComponents<ICanDie>();
        }

        #region Server

        public override void OnStartServer()
        {
            base.OnStartServer();
            maxHealth = health;
        }



        public virtual void ServerDealDamage(short damage, RaycastHit raycastHit)
        {
            health -= damage;
            if (health < 0)
            {
                health = 0;
                ServerDie();
            }
        }


        public void ServerHeal(short healingAmount)
        {
            health += (short)healingAmount;
            if (health > maxHealth)
            {
                health = maxHealth;
            }
        }

        public void ServerHealFull()
        {
            health = maxHealth;
        }

        
        public virtual void ServerDie()
        {
            OnServerDie?.Invoke();
            //Die();
            RpcDie();
        }



        #endregion

        #region Both sides
        void Die()
        {
            foreach (ICanDie canDie in aliveOrDeads)
            {
                canDie.Kill();
            }
        }

        #endregion

        #region RPCs

        [ClientRpc]
        void RpcDie()
        {
            //Die();
            OnClientDie();
        }

        #endregion

    }
}



