using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
using System;

namespace Core.ServerAuthoritativeActions
{
    public class ServerAuthoritativeMovement : NetworkBehaviour, ICanDie
    {

        [SerializeField] protected bool showDebugMessages = true;
        [SerializeField] protected int statesBufferSize = 16;
        [SerializeField] int inputsBufferSize = 16;


        Dictionary<ushort, StateSnapshot> statesBuffer = new Dictionary<ushort, StateSnapshot>();
        Dictionary<ushort, InputSnapshot> inputsBuffer = new Dictionary<ushort, InputSnapshot>();
        InputSnapshot currentInput = new InputSnapshot { tick = 1 };


        public event Action<ushort> OnClientMove=delegate { };

        public event Action<InputSnapshot> OnUseInput;

        public event Action<ushort> OnServerMove = delegate { };

        [SyncVar] protected bool someoneIsCommanding = false;

        [SyncVar(hook = nameof(ClientReceiveState))] public StateSnapshot state = new StateSnapshot() { tick = 0 };

        ushort currentTick = 0;
        public ushort CurrentTick { get => currentTick; }


        void ClientReceiveState(StateSnapshot _old, StateSnapshot _new)
        {
            if (statesBuffer.ContainsKey(_new.tick))
            {
                ClientCorrectState(statesBuffer[_new.tick], _new);
                statesBuffer.Clear();
                statesBuffer.Add(_new.tick, GenerateState(_new.tick));//usefull for uncontrolled ships
            }
            else
            {
                ClientForceState(_new);
                if (showDebugMessages)
                {
                    Debug.Log("state forced");
                }
            }
            
        }

        /*
        bool canMove = true;
        public bool CanMove
        {
            get => canMove;
            set => canMove = value;
        }
        */

        bool alive = true;


        const float STATE_SYNC_TIME = 1;

        

        protected virtual void FixedUpdate()
        {
            ApplyExternalForces();
            if (!alive)
            {
                return;
            }

            if (isClient)
            {
                if (hasAuthority)
                {
                    AuthoritativeClientLoop();
                }
                else
                {
                    NonAuthoritativeClientLoop();
                }

            }

            if (isServer)
            {
                ServerLoop();

            }
        


    }

        void AuthoritativeClientLoop()
        {

            ushort tick = TickManager.Tick;
            InputSnapshot generatedInput = ClientCollectInputs(tick);
            UseInput(generatedInput);
            statesBuffer.Add(tick, GenerateState(tick));
            
            CmdSendInput(generatedInput);
            OnClientMove(tick);
            currentTick = tick;
        }

        void NonAuthoritativeClientLoop()
        {
            if (someoneIsCommanding)
            {
                currentInput.tick++;
                currentInput = GetOldestInput();


                UseInput(currentInput);

                if (inputsBuffer.ContainsKey(currentInput.tick))
                {
                    inputsBuffer.Remove(currentInput.tick);
                }

            }
            else
            {
                inputsBuffer.Clear();
                currentInput.tick = TickManager.Tick;

            }


            if (!statesBuffer.ContainsKey(currentInput.tick))
            {
                statesBuffer.Add(currentInput.tick, GenerateState(currentInput.tick));
            }


            OnClientMove(currentInput.tick);
            currentTick = currentInput.tick;
        }
        void ServerLoop()
        {
            someoneIsCommanding = connectionToClient != null;


            if (someoneIsCommanding)
            {
                currentInput.tick++;
                currentInput = GetOldestInput();
                
                
                UseInput(currentInput);
                
                if (inputsBuffer.ContainsKey(currentInput.tick))
                {
                    inputsBuffer.Remove(currentInput.tick);
                }
                
            }
            else
            {
                inputsBuffer.Clear();
                currentInput.tick = TickManager.Tick;

            }


            if (ShouldServerGenerateState())
            {
                state = GenerateState(currentInput.tick);
            }
            OnServerMove(currentInput.tick);
            currentTick = currentInput.tick;

        }




        protected virtual void Update()
        {
            CleanInputsBuffer();
        }


        #region Client

        public override void OnStartAuthority()
        {
            base.OnStartAuthority();
            
            inputsBuffer.Clear();

        }

        protected virtual InputSnapshot ClientCollectInputs(ushort tick)
        {
            return new InputSnapshot { tick = tick };
        }
        protected virtual void ClientCorrectState(StateSnapshot bufferedState, StateSnapshot newState)
        {

        }
        protected virtual void ClientForceState(StateSnapshot newState)
        {

        }

        

        #endregion

        #region Both sides

        protected virtual void ApplyExternalForces()
        {

        }

        protected virtual void UseInput(InputSnapshot input)
        {
            OnUseInput?.Invoke(input);
        }
        protected virtual bool ShouldServerGenerateState()
        {
            return true;
        }

        protected virtual StateSnapshot GenerateState(ushort tick)
        {
            return new StateSnapshot { tick = tick };
        }

        void StoreInput(InputSnapshot input)
        {
            if (inputsBuffer.Count > inputsBufferSize)
            {
                inputsBuffer.Clear();
                if (showDebugMessages)
                {
                    Debug.LogError("input buffer cleared");
                }
            }
            if (!inputsBuffer.ContainsKey(input.tick) )
            {
                inputsBuffer.Add(input.tick, input);
                if (showDebugMessages)
                {
                    Debug.Log("input stored");
                }
            }
            else if (showDebugMessages)
            {
                Debug.LogError("input rejected");
            }
        }


        /// <summary>
        /// returns last used input if no input received on time
        /// </summary>
        /// <returns></returns>
        InputSnapshot GetOldestInput()
        {

            ushort oldestInputTick = ushort.MaxValue;
            foreach (KeyValuePair<ushort, InputSnapshot> inputSnap in inputsBuffer)
            {
                if (inputSnap.Key < oldestInputTick)
                {
                    oldestInputTick = inputSnap.Key;
                }
            }


            if (inputsBuffer.ContainsKey(oldestInputTick))
            {
                return inputsBuffer[oldestInputTick];
            }
            else
            {
                if (showDebugMessages)
                {
                    Debug.Log("no input received on time. assuming unchanged input");
                }

                return currentInput;
            }

        }

        void CleanInputsBuffer()
        {
            foreach (KeyValuePair<ushort, InputSnapshot> input in inputsBuffer)
            {
                if (input.Key < currentInput.tick)
                {
                    inputsBuffer.Remove(input.Key);
                    return;
                }
            }
        }



        #endregion

        #region Server 
        

        #endregion

        #region Commands 

        [Command(channel = Channels.Unreliable)]
        protected void CmdSendInput(InputSnapshot input)
        {
            StoreInput(input);
            RpcRelayInput(input);
        }

        #endregion

        #region RPCs

        [ClientRpc(channel = Channels.Unreliable, includeOwner = false)]
        void RpcRelayInput(InputSnapshot input)
        {
            if (enabled)
            {
                StoreInput(input);
            }

        }

        void ICanDie.Kill()
        {
            alive = false;
        }

        /*
        [ClientRpc(channel = Channels.DefaultUnreliable)]
        void RpcSendState(StateSnapshot newState)
        {
            if (showDebugMessages && state != null)
            {
                Debug.Log("deleting an unused state");
            }
            state = newState;
        }
        */





        #endregion


    }



}
