using UnityEngine;
using System.Collections;
using System;
using Mirror;

namespace Core.ServerAuthoritativeActions
{
    #region States
    public class StateSnapshot
    {
        public ushort tick;
    }
    public class CharacterWalkingSnapshot : StateSnapshot
    {
        public Vector3 position;
    }

    public class CharacterSnapshot : StateSnapshot
    {
        
        public NetworkIdentity parentIdentity;
        public Vector3 localPosition;
        public Quaternion localRotation;
    }

    public class ShipState : StateSnapshot
    {
        public Vector3 position;
        public Vector3 velocity;
        public Quaternion rotation;
    }

    public class TurretState : StateSnapshot
    {
        public float xRotation;
        public float yRotation;
    }

    public static class StateSerializer
    {
        const byte PLAYER_WALKING = 1;
        const byte PLAYER_MAGNETIC = 2;
        const byte SHIP = 4;
        const byte TURRET = 5;

        public static void WriteState(this NetworkWriter writer, StateSnapshot state)
        {
            if (state is CharacterWalkingSnapshot characterState)
            {
                writer.WriteByte(PLAYER_WALKING);
                writer.WriteUShort(characterState.tick);
                writer.WriteVector3(characterState.position);
                return;
            }
            if(state is CharacterSnapshot magneticState)
            {
                writer.WriteByte(PLAYER_MAGNETIC);                
                writer.WriteUShort(magneticState.tick);
                
                writer.WriteNetworkIdentity(magneticState.parentIdentity);
                writer.WriteVector3(magneticState.localPosition);
                writer.WriteQuaternion(magneticState.localRotation);
            }
            if (state is ShipState shipState)
            {
                writer.WriteByte(SHIP);
                writer.WriteUShort(shipState.tick);
                writer.WriteVector3(shipState.position);
                writer.WriteVector3(shipState.velocity);
                writer.WriteQuaternion(shipState.rotation);

                return;
            }
            if (state is TurretState turretState)
            {
                writer.WriteByte(TURRET);
                writer.WriteUShort(turretState.tick);
                writer.WriteFloat(turretState.xRotation);
                writer.WriteFloat(turretState.yRotation);
                return;
            }
        }

        public static StateSnapshot StateReader(this NetworkReader reader)
        {
            byte type = reader.ReadByte();
            switch (type)
            {
                case PLAYER_WALKING:
                    return new CharacterWalkingSnapshot
                    {
                        tick = reader.ReadUShort(),
                        position = reader.ReadVector3()
                    };
                case PLAYER_MAGNETIC:
                    return new CharacterSnapshot
                    {
                        tick = reader.ReadUShort(),
                        
                        parentIdentity = reader.ReadNetworkIdentity(),
                        localPosition = reader.ReadVector3(),
                        localRotation = reader.ReadQuaternion(),
                    };
                case SHIP:
                    return new ShipState
                    {
                        tick = reader.ReadUShort(),
                        position = reader.ReadVector3(),
                        velocity = reader.ReadVector3(),
                        rotation = reader.ReadQuaternion(),
                    };

                case TURRET:
                    return new TurretState
                    {
                        tick = reader.ReadUShort(),
                        xRotation = reader.ReadFloat(),
                        yRotation = reader.ReadFloat(),
                    };

                default:
                    throw new Exception($"Invalid state type {type}");

            }
        }
    }



    #endregion

    #region Inputs
    public class InputSnapshot
    {
        public ushort tick;
    }

    public class CharacterInput : InputSnapshot
    {
        public float forwardBackward;
        public float rightLeft;
        public bool jump;
        public float xRotation;
        public float yRotation;
    }
    public class ShipInput : InputSnapshot
    {
        public float yaw;
        public float pitch;
        public float roll;
        public float thrust;

    }
    public class TurretInput : InputSnapshot
    {
        public float xRotation;
        public float yRotation;
    }


    public static class InputSerializer
    {
        const byte EMPTY = 0;
        const byte CHARACTER = 1;
        const byte SHIP = 2;
        const byte TURRET = 3;


        public static void WriteInput(this NetworkWriter writer, InputSnapshot input)
        {
            if (input is CharacterInput characterInput)
            {
                writer.WriteByte(CHARACTER);
                writer.WriteUShort(characterInput.tick);
                writer.WriteFloat(characterInput.forwardBackward);
                writer.WriteFloat(characterInput.rightLeft);
                writer.WriteBool(characterInput.jump);
                writer.WriteFloat(characterInput.xRotation);
                writer.WriteFloat(characterInput.yRotation);
                return;
            }
            if (input is ShipInput shipInput)
            {
                writer.WriteByte(SHIP);
                writer.WriteUShort(shipInput.tick);
                writer.WriteFloat(shipInput.yaw);
                writer.WriteFloat(shipInput.pitch);
                writer.WriteFloat(shipInput.roll);
                writer.WriteFloat(shipInput.thrust);

                return;
            }
            if(input is TurretInput turretInput)
            {
                writer.WriteByte(TURRET);
                writer.WriteFloat(turretInput.xRotation);
                writer.WriteFloat(turretInput.yRotation);
                return;
            }

            else
            {
                writer.WriteByte(EMPTY);
                writer.WriteUShort(input.tick);
            }

        }

        public static InputSnapshot ReadInputSnapShot(this NetworkReader reader)
        {
            byte type = reader.ReadByte();
            switch (type)
            {
                case EMPTY:

                    return new InputSnapshot
                    {
                        tick = reader.ReadUShort()
                    };

                case CHARACTER:
                    return new CharacterInput
                    {
                        tick = reader.ReadUShort(),
                        forwardBackward = reader.ReadFloat(),
                        rightLeft = reader.ReadFloat(),
                        jump = reader.ReadBool(),
                        xRotation = reader.ReadFloat(),
                        yRotation = reader.ReadFloat()
                    };
                case SHIP:
                    return new ShipInput
                    {
                        tick = reader.ReadUShort(),
                        yaw = reader.ReadFloat(),
                        pitch = reader.ReadFloat(),
                        roll = reader.ReadFloat(),
                        thrust = reader.ReadFloat()

                    };
                case TURRET:
                    return new TurretInput
                    {
                        tick = reader.ReadUShort(),
                        xRotation = reader.ReadFloat(),
                        yRotation = reader.ReadFloat()
                    };

                default:
                    throw new Exception($"Invalid Input type {type}");
            }
        }
    }
    #endregion


}